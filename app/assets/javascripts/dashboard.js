/* global document, $ */

const offsetTop = 164;

$(document).ready(() => {
  $(document).scroll(() => {
    if (document.documentElement.scrollTop > offsetTop) {
      $('#sticky-head, #sticky-corner').css({ top: (document.documentElement.scrollTop) - offsetTop, position: 'relative' });
    } else {
      $('#sticky-head, #sticky-corner').css({ top: 0, position: 'inherit' });
    }
  });
});
