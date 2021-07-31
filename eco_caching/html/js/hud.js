let hud = {};
let hudWrapper = $("#hudWrapper");

let statusWrapper = $("#statusWrapper");
let generalWrapper = $("#generalWrapper");
let actionWrapper = $("#actionWrapper");


function closeHud(identifier) {

    $.when($(identifier).fadeOut()).done(function () {
        $(identifier).remove();
    });
}

function geoInfo(data) {

    if (!$.isEmptyObject(data)) {

        statusWrapper.empty();

        let template = $(".hud").clone();
        template.removeClass("template");
        template.addClass("gInfo");

        hud = {
            opened: template.find(".opened"),
            hit: template.find(".hit"),

            point: template.find(".point"),
            coin: template.find(".coin")
        };

        hud.opened.html(data.opened);
        hud.hit.html(data.hit);
        hud.point.html(data.point);
        hud.coin.html(data.coin);

        statusWrapper.html(template);
        hudWrapper.css("display", "block");
    }
}

function updateHud(value) {

    if (jQuery.isEmptyObject(hud)) {
        return false
    }

    Object.keys(value).forEach(function (k) {

        if (hud[k] instanceof jQuery) {
            hud[k].html(value[k])
        }
    });
}

function actionInfo(value) {

    actionWrapper.empty();

    let aInfo = $(".actionInformation").clone();
    aInfo.removeClass("template").addClass("aInfo");

    aInfo.find(".msgActionTitle").html(value.name);
    aInfo.find(".msgDescription").html(value.description);
    aInfo.find(".msgActionMsg").html(value.message);
    aInfo.fadeIn();
    actionWrapper.html(aInfo);
}

let persistentNotifs = {};

function CreateNotification(data) {
    let $notification = $(document.createElement('div'));
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn();
    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function (css) {
            $notification.css(css, data.style[css])
        });
    }

    return $notification;
}

function ShowNotification(data) {

    if (data.persist === undefined) {

        let $notification = CreateNotification(data);
        generalWrapper.append($notification);

        setTimeout(function () {
            $.when($notification.fadeOut()).done(function () {
                $notification.remove();
            });
        }, data.length != null ? data.length : 8000);

    } else {
        if (data.persist.toUpperCase() === 'START') {
            if (persistentNotifs[data.id] === undefined) {
                let $notification = CreateNotification(data);
                generalWrapper.append($notification);
                persistentNotifs[data.id] = $notification;
            } else {
                let $notification = $(persistentNotifs[data.id]);
                $notification.addClass('notification').addClass(data.type);
                $notification.html(data.text);

                if (data.style !== undefined) {
                    Object.keys(data.style).forEach(function (css) {
                        $notification.css(css, data.style[css])
                    });
                }
            }
        } else if (data.persist.toUpperCase() === 'END') {
            let $notification = $(persistentNotifs[data.id]);
            $.when($notification.fadeOut()).done(function () {
                $notification.remove();
                delete persistentNotifs[data.id];
            });
        }
    }
}

function ShowPopupNotification(data) {

    let reward = data.reward;

    let rewardPopup = $('#rewardPopup');

    let congratulation = rewardPopup.find('.popupCongratulation');
    let placement = rewardPopup.find('.popupPlacement');
    let money = rewardPopup.find('.popupMoney');
    let item = rewardPopup.find('.popupItem');
    let coin = rewardPopup.find('.popupCoin');
    let point = rewardPopup.find('.popupPoint');


    congratulation.css('display', 'none');
    money.parent().css('display', 'none');
    item.parent().css('display', 'none');
    coin.parent().css('display', 'none');
    point.parent().css('display', 'none');


    if (data.placement > 0) {

        placement.html(data.placement);
        congratulation.css('display', 'block');
    }

    if (reward.money > 0) { money.html(reward.money).parent().css('display', 'flex'); }
    if (reward.coin > 0) { coin.html(reward.coin).parent().css('display', 'flex'); }
    if (reward.point > 0) { point.html(reward.point).parent().css('display', 'flex'); }
    if (reward.item !== '') { item.html(reward.item).parent().css('display', 'flex'); }


    rewardPopup.find('.popupTitle').html(data.title);
    rewardPopup.find('.popupImg').attr("src",("img/chest_%s.png").format(data.state));
    rewardPopup.find('.popupText').html(data.text);

    rewardPopup.fadeIn();

    setTimeout(function () {
        $.when(rewardPopup.fadeOut()).done(function () {});
    }, 8000);
}