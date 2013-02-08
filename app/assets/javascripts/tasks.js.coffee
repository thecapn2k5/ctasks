Initialize = ->
  $(".addnewtask").unbind "click"
  $(".togglehidetask").unbind "click"
  $(".destroytask").unbind "click"
  $(".taskname").unbind "change"
  $(".addnewtask").click ->
    task_id = $(this).attr("id").slice(10)
    AddNew task_id

  $(".togglehidetask").click ->
    task_id = $(this).attr("id").slice(14)
    ToggleHide task_id

  $(".destroytask").click ->
    task_id = $(this).attr("id").slice(11)
    Destroy task_id

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
      $("li#task button.togglehidetask").attr "id", "togglehidetask" + task_id
      $("li#task button.destroytask").attr "id", "destroytask" + task_id
      $("li#task ul").attr "id", "tasks" + task_id
      cloned = $("li#task").clone()
      $("#tasks" + parent_id).append cloned
      $("#tasks" + parent_id + " li:last").attr "id", "task" + task_id
      $("#tasks" + parent_id + " li:last").css "display", "list-item"
      Initialize()
      SaveSort $("#tasks" + parent_id)

ToggleHide = (task_id) ->
  $.getJSON "/toggle_hide_task",
    id: task_id
  , (data) ->
    $("#task" + data + " #taskfunctions" + data + " .togglehidetask").toggleClass "hideme"
    $("#task" + data).toggleClass "hiddentask"
    if $("#task" + data).hasClass("hiddentask") and $("#hidehidden").hasClass("hideme")
      $("#task" + data).addClass "hideme"
    else
      $("#task" + data).removeClass "hideme"

Destroy = (task_id) ->
  if confirm("Are you sure you want to premanently delete this task and all sub-tasks?")
    $.getJSON "/destroy_task",
      id: task_id
    , (data) ->
      $("#task" + String(data)).remove()

ChangeName = (task_id) ->
  name = $("#taskname" + task_id).val()
  $.post "/change_task_name",
    id: task_id
    name: name

$(document).ready ->
  Initialize()
  $('#showhidden').click ->
    $(".hiddentask").removeClass "hideme"
    $("button.togglehidden").toggleClass "hideme"

  $('#hidehidden').click ->
    $(".hiddentask").addClass "hideme"
    $("button.togglehidden").toggleClass "hideme"
