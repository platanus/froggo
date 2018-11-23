/* global document, $ */

const offsetTop = 164;
const autoscrollInterval = 10000;

$(document).ready(() => {
  $(document).scroll(() => {
    if (document.documentElement.scrollTop > offsetTop) {
      $('#sticky-head, #sticky-corner').css({ top: (document.documentElement.scrollTop) - offsetTop, position: 'relative' });
    } else {
      $('#sticky-head, #sticky-corner').css({ top: 0, position: 'inherit' });
    }
  });
});

$(document).ready(() => {
  let upToDown = true;
  setInterval(() => {
    const fullscreenDashboard = $('.card-extended--fullscreen')[0];
    if (fullscreenDashboard.scrollTop >= fullscreenDashboard.scrollHeight - fullscreenDashboard.offsetHeight) {
      upToDown = false;
    } else if (fullscreenDashboard.scrollTop === 0) {
      upToDown = true;
    }
    if (window.location.href.includes('public')) {
      if (upToDown) {
        fullscreenDashboard.scrollBy(0, fullscreenDashboard.offsetHeight);
      } else {
        fullscreenDashboard.scrollBy(0, -fullscreenDashboard.offsetHeight);
      }
    }
  }, autoscrollInterval);
});
