import "@rails/activestorage"

import "@hotwired/turbo-rails"
import "./controllers"

import "./channels"
import "jquery"

jQuery(document).on('turbo:load', () => {
    console.log('turbo!')

    const times = document.getElementsByTagName("time");
    for (const t of times) {
        const dateTime = luxon.DateTime.fromISO(t.textContent);
        t.textContent = dateTime.toFormat("ffff");
    }
})

import '@fortawesome/fontawesome-free/js/all.js';