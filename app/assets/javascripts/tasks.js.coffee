Initialize = ->
   $(".addnewtask").unbind "click"
   $(".togglehidetasks").unbind "click"
   $(".promptdelete").unbind "click"
   $(".canceldelete").unbind "click"
   $(".confirmdelete").unbind "click"
   $(".taskname").unbind "keyup"
   $(".taskname").unbind "change"
   $(".addnewtask").click ->
      task_id = $(this).attr("id").slice(10)
      PromptNew task_id

   $(".togglehidetasks").click ->
      task_id = $(this).attr("id").slice(15)
      ToggleHide task_id

   $(".promptdelete").click ->
      task_id = $(this).attr("id").slice(12)
      PromptDelete task_id

   $(".canceldelete").click ->
      CancelDelete()

   $(".confirmdelete").click ->
      task_id = $(this).attr("id").slice(13)
      ConfirmDelete task_id

   $(".taskname").keyup ->
      task_id = $(this).attr("id").slice(8)
      CheckEdit task_id

   $(".taskname").change ->
      task_id = $(this).attr("id").slice(8)
      ChangeName task_id

   $("ul.tasks").sortable
      placeholder: "ui-state-highlight"
      revert: true
      forcePlaceholderSize: true
      update: (event, ui) ->
         container = ui.item.parent()
         SaveSort container

   $(".togglehidetasks.blank").unbind "click"

SaveSort = (container) ->
   tasks = ""
   container.children("li").each (i) ->
      id = $(this).attr("id")
      tasks += id.slice(4) + ","  unless id is "task"

   tasks = tasks.slice(0, -1)
   $.post "/save_task_sort",
      tasks: tasks

PromptNew = (parent_id) ->
   # get the new prompt and put it in the right place
   $(".clonedprompt").remove()
   cloned = $("#clonemeprompt").clone()
   cloned.attr "id", "clonedprompt" + parent_id
   cloned.addClass("clonedprompt")
   $("#tasks"+parent_id).append cloned
   $("#tasks"+parent_id+" .taskname").focus()
   $("#clonedprompt"+parent_id+" .savenew").attr "id", "savenew" + parent_id

   # make sure that the cancel button works
   $(".cancelnew").unbind "click"
   $(".cancelnew").click ->
      $(".clonedprompt").remove()

   # make sure that the save button works
   $(".savenew").unbind "click"
   $(".savenew").click ->
      parent_id = $(this).attr("id").slice(7)
      SaveNew parent_id

   # catch the keyup so it doesn't over-stretch
   $("#tasks"+parent_id+" .taskname").keyup ->
      length = $("#tasks"+parent_id+" .taskname").val().length
      if length > 75
         text = $("#tasks"+parent_id+" .taskname").val().slice(0,75)
         $("#tasks"+parent_id+" .taskname").val(text)
         $("#tasks"+parent_id+" .charactercount").text(0)

      else
         $("#tasks"+parent_id+" .charactercount").text(75 - length)


SaveNew = (parent_id) ->
   name = $("#clonedprompt"+parent_id+" .taskname").val()
   name = name.trim() if name

   if name and name.length > 75
      alert "Task names cannot be more than 75 characters long. Yours was "+String(name.length)+" characters."
   else if name
      $.getJSON "/add_task",
         name: name
         parent_id: parent_id
      , (data) ->
         $(".clonedprompt").remove()
         task_id = data["id"]

         # fill in the input
         cloned = $("li#task").clone()
         cloned.attr "id", "task" + task_id
         $("#tasks"+parent_id).append cloned

         # set the li id to the selector
         selector = "#task"+task_id

         # the name
         $(selector+" .taskname").val name

         # ids for various elements
         $(selector+" .taskname").attr "id", "taskname"                 + task_id
         $(selector+" .addnewtask").attr "id", "addnewtask"             + task_id
         $(selector+" .promptdelete").attr "id", "promptdelete"         + task_id
         $(selector+" .confirmdelete").attr "id", "confirmdelete"       + task_id
         $(selector+" #togglehidetasks").attr "id", "togglehidetasks"   + task_id
         $(selector+" ul").attr "id", "tasks"                           + task_id

         # make sure the parent has the collapse enabled
         $("#togglehidetasks"+parent_id).addClass "togglehidetasks"
         $("#togglehidetasks"+parent_id+" img").attr("src", "/assets/accordion_opened.png")

         # show the new one
         $(selector).css "display", "list-item"

         # increment the tasks count
         $("#taskscount").text parseInt($("#taskscount").text()) + 1

         Initialize()
         SaveSort $("#tasks" + parent_id)

ToggleHide = (task_id) ->
   $.getJSON "/toggle_hide_task",
      id: task_id
   , (data) ->
      $("#task" + data + " #tasks" + task_id).collapse "toggle"
      if $("#togglehidetasks"+task_id+ " img").attr("src") == "/assets/accordion_opened.png"
         $("#togglehidetasks"+task_id+ " img").attr("src", "/assets/accordion_closed.png")
      else
         $("#togglehidetasks"+task_id+ " img").attr("src", "/assets/accordion_opened.png")


PromptDelete = (task_id) ->
   $(".pendingdelete").removeClass "pendingdelete"
   $("#task"+task_id).addClass "pendingdelete"

CancelDelete = ->
   $(".pendingdelete").removeClass "pendingdelete"

ConfirmDelete = (task_id) ->
   $.getJSON "/destroy_task",
      id: task_id
   , (data) ->
      task_id = data["id"]
      any = data["any"]

      $("#taskscount").text data["taskscount"]
      $("#task" + task_id).remove()
      if any == "false"
         $("#togglehidetasks"+data["parent_id"]+ " img").attr("src", "/assets/accordion_blank.png")
         $("#togglehidetasks"+data["parent_id"]).removeClass "togglehidetasks"


CheckEdit = (task_id) ->
   target = "#taskname"+task_id
   length = $(target).val().length
   if length > 75
      text = $(target).val().slice(0,75)
      $(target).val(text)
      $("#editlengthwarning").show(300, HideWarning)

HideWarning = ->
   $("#editlengthwarning").delay(4000).hide(700)


ChangeName = (task_id) ->
   name = $("#taskname" + task_id).val()
   $.post "/change_task_name",
      id: task_id
      name: name


$(document).ready ->
   Initialize()
