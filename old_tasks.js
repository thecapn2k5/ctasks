$(document).ready(function(){
   Initialize();
});

function Initialize(){
   $('.addnewtask').unbind('click');
   $('.togglehidetask').unbind('click');
   $('.destroytask').unbind('click');
   $('.taskname').unbind('change');

   $('.addnewtask').click(function(){
      var task_id = $(this).attr('id').slice(10);
      AddNew(task_id);
   });
   $('.togglehidetask').click(function(){
      var task_id = $(this).attr('id').slice(14);
      ToggleHide(task_id);
   });
   $('.destroytask').click(function(){
      var task_id = $(this).attr('id').slice(11);
      Destroy(task_id);
   });

   $('.taskname').change(function(){
      var task_id = $(this).attr('id').slice(8);
      ChangeName(task_id)
   });

   $('ul.tasks').sortable({
      placeholder: "ui-state-highlight",
      revert: true,
      forcePlaceholderSize: true,
      update: function(event, ui){
         var container = ui.item.parent();
         SaveSort(container)
      },
   });
};

function SaveSort(container){
   var tasks = "";
   container.children('li').each(function(i){
      var id = $(this).attr('id');
      if (id != "task"){
         tasks += id.slice(4)+",";
      }
   });
   var tasks = tasks.slice(0,-1);

   $.post("/save_task_sort", {"tasks":tasks});
};

function ShowHidden() {
   $('.hiddentask').removeClass('hideme');
   $('button.togglehidden').toggleClass('hideme');
};

function HideHidden() {
   $('.hiddentask').addClass('hideme');
   $('button.togglehidden').toggleClass('hideme');
}

function AddNew(parent_id) {
   var name = prompt("Name for new task:");
   if (name) { name = name.trim(); }
   if (name) {
      $.getJSON("/add_task", {"name":name, "parent_id":parent_id}, function(data){
         var task_id = data['id'];
         $("li#task .taskname").val(name);
         $("li#task input.taskname").attr('id', 'taskname'+task_id);
         $("li#task button.addnewtask").attr('id', 'addnewtask'+task_id);
         $("li#task button.togglehidetask").attr('id', 'togglehidetask'+task_id);
         $("li#task button.destroytask").attr('id', 'destroytask'+task_id);
         $("li#task ul").attr('id', 'tasks'+task_id)
         var cloned = $("li#task").clone();
         $("#tasks"+parent_id).append(cloned);
         $("#tasks"+parent_id+" li:last").attr('id', 'task'+task_id);
         $("#tasks"+parent_id+" li:last").css('display', 'list-item');
         Initialize();
         SaveSort($("#tasks"+parent_id));
      });
   }
};

function ToggleHide(task_id) {
   $.getJSON("/toggle_hide_task", {"id":task_id}, function(data){
      $("#task"+data+" #taskfunctions"+data+" .togglehidetask").toggleClass('hideme');
      $("#task"+data).toggleClass('hiddentask');
      if ($("#task"+data).hasClass('hiddentask') && $('#hidehidden').hasClass('hideme')){
         $("#task"+data).addClass('hideme');
      } else {
         $("#task"+data).removeClass('hideme');
      }
   });
};

function Destroy(task_id) {
   if (confirm("Are you sure you want to premanently delete this task and all sub-tasks?")){
      $.getJSON("/destroy_task", {"id":task_id}, function(data){
         $("#task"+String(data)).remove();
      });
   }
};

function ChangeName(task_id) {
   var name = $("#taskname"+task_id).val();
   $.post("/change_task_name", {"id":task_id, "name":name});
}
