$(document).ready(function(){
   GetHandles();
});

function GetHandles(){
   $('.addnewtask').unbind('click');
   $('.togglehidetask').unbind('click');
   $('.destroytask').unbind('click');

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
};

function ShowHidden() {
   $('.hiddentask').css('display', 'list-item');
   $('button.togglehidden').toggleClass('hideme');
};

function HideHidden() {
   $('.hiddentask').css('display', 'none');
   $('button.togglehidden').toggleClass('hideme');
}

function AddNew(parent_id) {
   var name = prompt("Name for new task:").trim();
   if (name) {
      var task_id = "newbuddy"
      $("li#task .taskname").text(name);
      $("li#task button.addnewtask").attr('id', 'addnewtask'+task_id);
      $("li#task button.togglehidetask").attr('id', 'togglehidetask'+task_id);
      $("li#task button.destroytask").attr('id', 'destroytask'+task_id);
      $("li#task ul").attr('id', 'tasks'+task_id)
      var cloned = $("li#task").clone();
      $("#tasks"+parent_id).append(cloned);
      $("#tasks"+parent_id+" li:last").attr('id', 'task'+task_id);
      $("#tasks"+parent_id+" li:last").css('display', 'list-item');
      GetHandles();
   }
};

function ToggleHide(task_id) {
   $("#task"+String(task_id)+" .togglehide").toggleClass('hideme');
   $("#task"+String(task_id)).toggleClass('hiddentask');

};

function Destroy(task_id) {
   if (confirm("Are you sure you want to premanently delete this task and all sub-tasks?")){
      $("#task"+String(task_id)).remove();
   }
};
