/* global document, $ */

const offsetTop = 164;

$(document).ready(() => {
  $(document).scroll(() => {
    if (document.documentElement.scrollTop > offsetTop) {
      $('#sticky-head').css({ top: (document.documentElement.scrollTop) - offsetTop, position: 'relative' });
    } else {
      $('#sticky-head').css({ top: 0, position: 'inherit' });
    }
  });
});
