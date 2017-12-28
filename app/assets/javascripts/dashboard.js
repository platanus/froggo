document.addEventListener('DOMContentLoaded', function() {
  var i = 0;
  var melements = document.getElementsByClassName('matrix__pullrequest__number');
  for(i = 0; i < melements.length; i++){
    if(melements[i].innerHTML.replace(/\s/g,'') === "0"){
      melements[i].className = 'matrix__pullrequest__number-0';
    }
  }
}, false);