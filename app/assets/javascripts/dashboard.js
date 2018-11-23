/* global document, $ */

const offsetTop = 164;
const autoscrollInterval = 10000;

$(document).ready(() => {
  $(document).scroll(() => {
    if ($('.card-extended--fullscreen')[0]) {
      return;
    }
    if (document.documentElement.scrollTop > offsetTop) {
      $('#sticky-head, #sticky-corner').css({ top: (document.documentElement.scrollTop) - offsetTop, position: 'relative' });
    } else {
      $('#sticky-head, #sticky-corner').css({ top: 0, position: 'inherit' });
    }
  });
});

$(document).ready(() => {
  let upToDown = true;
  if (window.location.href.includes('public')) {
    setInterval(() => {
      const viewport = document.documentElement;
      if (viewport.scrollTop >= viewport.scrollHeight - viewport.clientHeight) {
        upToDown = false;
      } else if (viewport.scrollTop === 0) {
        upToDown = true;
      }
      if (upToDown) {
        viewport.scrollBy(0, viewport.clientHeight);
      } else {
        viewport.scrollBy(0, -viewport.clientHeight);
      }
    }, autoscrollInterval);
  }
});
