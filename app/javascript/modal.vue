<template>
  <transition name="modal">
    <div class="modal__mask">
      <div class="modal__wrapper">
        <div class="modal-container">
          <div class="modal__header">
            <slot name="modal__header__content">
              <h3 class="modal__header__title" slot="modal__header__content">Panel de configuración</h3>
            </slot>
          </div>
          <div class="modal__body">
            <slot name="modal__body__content">
              Aquí puedes configurar, trackear y destrackear tus repositorios.
            </slot>
          </div>
          <div class="modal__footer">
            <slot name="modal__footer__content">
              <button class="modal__default__button" @click="$emit('close')">
                OK
              </button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

