require("@rails/activestorage").start()
require("channels")
require("jquery")
require("@popperjs/core")
require("bootstrap")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"
import "@hotwired/turbo-rails"

jQuery(document).on('turbo:load', () => {
    console.log('turbo!')

    const times = document.getElementsByTagName("time");
    for (const t of times) {
        const dateTime = luxon.DateTime.fromISO(t.textContent);
        t.textContent = dateTime.toFormat("ffff");
    }
})
