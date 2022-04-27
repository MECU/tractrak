const { DateTime } = require("luxon");

const times = document.getElementsByTagName("time");
for (const t of times) {
    const dateTime = DateTime.fromISO(t.textContent);
    t.textContent = dateTime.toFormat("ffff");
}
