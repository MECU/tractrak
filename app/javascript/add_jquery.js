import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

jQuery(document).on('turbo:load', () => {
    console.log('turbo!')
})
