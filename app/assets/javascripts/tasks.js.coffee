Initialize = ->
  $(".addnewtask").unbind "click"
  $(".togglehidetasks").unbind "click"
  $(".promptdelete").unbind "click"
  $(".canceldelete").unbind "click"
  $(".confirmdelete").unbind "click"
  $(".taskname").unbind "change"
  $(".addnewtask").click ->
    task_id = $(this).attr("id").slice(10)
    AddNew task_id

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

SaveSort = (container) ->
  tasks = ""
  container.children("li").each (i) ->
    id = $(this).attr("id")
    tasks += id.slice(4) + ","  unless id is "task"

  tasks = tasks.slice(0, -1)
  $.post "/save_task_sort",
    tasks: tasks

AddNew = (parent_id) ->
  name = prompt("Name for new task:")
  name = name.trim()  if name
  if name
    $.getJSON "/add_task",
      name: name
      parent_id: parent_id
    , (data) ->
      task_id = data["id"]
      $("li#task .taskname").val name
      $("li#task input.taskname").attr "id", "taskname" + task_id
      $("li#task button.addnewtask").attr "id", "addnewtask" + task_id
      $("li#task button.destroytask").attr "id", "destroytask" + task_id
      $("li#task ul").attr "id", "tasks" + task_id
      cloned = $("li#task").clone()
      $("#tasks"+parent_id).append cloned
      $("#tasks"+parent_id+" li:last").attr "id", "task" + task_id
      $("#tasks"+parent_id+" li:last").css "display", "list-item"
      $("#tasks"+parent_id+" li:last").css "display", "list-item"
      $("#tasks"+parent_id+" #togglehidetasks").attr "id", "togglehidetasks" + task_id
      $("#togglehidetasks"+parent_id).addClass "togglehidetasks"
      $("#togglehidetasks"+parent_id+ " img").attr("src", "/assets/accordion_opened.png")

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

ChangeName = (task_id) ->
  name = $("#taskname" + task_id).val()
  $.post "/change_task_name",
    id: task_id
    name: name

$(document).ready ->
  Initialize()
