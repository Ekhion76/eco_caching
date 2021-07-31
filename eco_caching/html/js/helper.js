const MONEY = new Intl.NumberFormat('en-US',
    {
        style: 'currency', currency: 'USD',
        minimumFractionDigits: 0
    });

String.prototype.format = function () {
    return [...arguments].reduce((p, c) => p.replace(/%s/, c), this);
};

function millisecond2date(millisecond, locale, options) {

    let localeString = locale || 'hu-HU';

    options = options || { month: 'short', day: '2-digit' };
    return new Date(millisecond).toLocaleDateString(localeString, options)
}

function displayElapsedTime(elapsedTime) {

    if (elapsedTime < 60) {

        return {time: elapsedTime, unit: 'sec'}
    }

    let hours = Math.floor(elapsedTime / 3600);
    let minutes = Math.floor(elapsedTime % 3600) / 3600;

    minutes = minutes.toFixed(1) * 1;

    if (hours < 1) {

        minutes = Math.floor(elapsedTime / 60);
        return {time: minutes, unit: 'min'}
    }

    return {time: hours + minutes, unit: 'h'}
}

function jsonParse(str) {

    if (typeof (str) === "undefined" || jQuery.trim(str) === "") {

        return false
    }
    try {

        return (JSON.parse(str));
    } catch (e) {

        return false;
    }
}


function getTimeStamp() {

    return Date.now() / 1000;
}