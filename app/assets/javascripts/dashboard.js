/* global document, $ */

const offsetTop = 164;

$(document).ready(() => {
  $(document).scroll(() => {
    if ($('.card-extended--fullscreen')[0]) {
      return;
    }
    if ($(document).scrollTop() > offsetTop) {
      $('#sticky-head, #sticky-corner').css({ top: ($(document).scrollTop()) - offsetTop, position: 'relative' });
    } else {
      $('#sticky-head, #sticky-corner').css({ top: 0, position: 'inherit' });
    }
  });
});
