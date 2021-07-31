let lastEventTime = 0;
let missionOrderBy = 'opened';
let floodProtectionTime = 2; // in sec
let floodMessage = ('Flood védelem: Várj %s másodpercet').format(floodProtectionTime);
let itemList = {};


function closePage() {

    $('#page').empty().css("display", "none");
    $('.pageWrapper').css("display", "none");
}

function icons(properties) {

    let out = "";

    if (!jQuery.isEmptyObject(properties)) {

        properties.forEach(function (v, k) {

            out += "<img src='img/" + v + ".png' class='propertyIcon'>";
        });

    }

    return out;
}

function getExpire(data, osTime) {

    let remainingTime = data.expire - osTime;

    if (data.active === '1' && remainingTime > 0) {

        let res = displayElapsedTime(remainingTime);
        return res.time + ' ' + res.unit
    }

    return '-';
}

function controlBtnHandler(sData, eData, controlContainer, osTime) {

    let sStop = controlContainer.find("#sStop");
    let sStart = controlContainer.find("#sStart");

    let eStop = controlContainer.find("#eStop");
    let eStart = controlContainer.find("#eStart");

    sStop.css('display', 'none');
    sStart.css('display', 'none');
    eStop.css('display', 'none');
    eStart.css('display', 'none');


    if (sData.active === '1' && (sData.expire === 0 || (sData.expire - osTime) > 0)) {

        sStop.css('display', 'block');
        sStop.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/control', JSON.stringify({
                    sid: 1,
                    active: '0',
                    expire: null
                }), function (response) {

                    openControl(response);
                });

            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });
    } else {

        sStart.css('display', 'block');
        sStart.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                let form = $('#standardForm');
                let input = form.find('input[type=number]');

                let allocationObj = {};

                for (let i = 0; i < input.length; i++) {

                    let inputId = input[i].id;
                    let id = inputId.split("_")[1];

                    if (input[i].max && (input[i].max * 1 < input[i].value * 1)) {

                        input[i].value = input[i].max
                    }

                    allocationObj[id] = input[i].value * 1;
                }


                $.post('https://eco_caching/control', JSON.stringify({
                    sid: 1,
                    active: '1',
                    expire: null,
                    state_allocation: JSON.stringify(allocationObj)
                }), function (response) {

                    openControl(response);
                });

            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });
    }


    if (eData.active === '1' && (eData.expire === 0 || (eData.expire - osTime) > 0)) {

        eStop.css('display', 'block');
        eStop.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/control', JSON.stringify({
                    sid: 2,
                    active: '0',
                    expire: null
                }), function (response) {

                    openControl(response);
                });

            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });
    } else {

        eStart.css('display', 'block');
        eStart.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/control', JSON.stringify({
                    sid: 2,
                    active: '1',
                    expire: controlContainer.find("#eInterval").val()
                }), function (response) {

                    openControl(response);
                });

            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });

    }
}

function openControl(data) {


    let osTime = data.osTime;
    let sData = data.sessionData[0];
    let eData = data.sessionData[1];

    let pageWrapper = $(".pageWrapper");
    pageWrapper.find(".titleContainer").css("display", "none");

    let page = $("#page");
    page.empty();

    let controlContainer = $(".controlContainer").clone();
    controlContainer.removeClass("template");


    controlBtnHandler(sData, eData, controlContainer, osTime);

    let sAllocation = jsonParse(sData.state_allocation);

    controlContainer.find(".sStatus").html(sData.active === '1' ? 'Bekapcsolva' : 'Kikapcsolva');
    controlContainer.find(".sExpire").html(getExpire(sData, osTime));

    Object.keys(sAllocation).forEach(function (k) {

        controlContainer.find("#zone_" + k).val(sAllocation[k]);
    });

    controlContainer.find(".eStatus").html(eData.active === '1' ? 'Bekapcsolva' : 'Kikapcsolva');
    controlContainer.find(".eExpire").html(getExpire(eData, osTime));


    controlContainer.appendTo(page);
    pageWrapper.css("display", "block");
    page.css("display", "block");
}

function openStatistics(data, statType) {

    statType = statType || 'myStatistics';


    let pageWrapper = $(".pageWrapper");
    pageWrapper.find(".titleContainer").css("display", "none");

    let page = $("#page");
    page.empty();

    let statisticsContainer = $(".statisticsContainer").clone();
    statisticsContainer.removeClass("template");

    let statisticsContent = statisticsContainer.find(".statisticsContent");

    let myStatisticsBtn = statisticsContainer.find("#myStatisticsBtn");
    let summaryStatisticsBtn = statisticsContainer.find("#summaryStatisticsBtn");
    let ranksBtn = statisticsContainer.find("#ranksBtn");

    if (statType !== 'myStatistics') {

        myStatisticsBtn.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/myStatistics', JSON.stringify({}));
            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }
            return false;
        });

    }

    if (statType !== 'allStatistics') {

        summaryStatisticsBtn.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/getAllStatistics', JSON.stringify({

                    orderBy: missionOrderBy
                })).then(
                    resp => {

                        openStatistics(jsonParse(resp), 'allStatistics')
                    }
                );
            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });

    }

    if (statType !== 'ranks') {

        ranksBtn.click(function () {

            if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                lastEventTime = getTimeStamp();

                $.post('https://eco_caching/getRanks', JSON.stringify({})).then(
                    resp => {

                        openStatistics(jsonParse(resp), 'ranks')
                    }
                );
            } else {

                ShowNotification({type: 'fail', text: floodMessage});
            }

            return false;
        });
    }


    if (statType === 'allStatistics') {

        if (!$.isEmptyObject(data)) {

            let summaryStatistics = $(".summaryStatistics").clone();
            summaryStatistics.removeClass("template");


            let statisticsItemContainer = summaryStatistics.find(".summaryStatisticsItemContainer");
            let itemTmp = statisticsItemContainer.find(".summaryStatisticsItem");
            statisticsItemContainer.removeClass("template");

            statisticsItemContainer.find("option:selected").removeAttr("selected");
            statisticsItemContainer.find("option[value='" + missionOrderBy + "']").attr('selected', 'selected');


            for (let i = 0; i < data.length; i++) {

                let cData = data[i];

                let item = itemTmp.clone();
                item.removeClass("template");

                let name = ("%s %s").format(cData.firstname, cData.lastname);

                item.addClass('itemStyle' + cData.rank);
                item.find(".summaryStatValueName").html(("%s. %s").format(i + 1, name));
                item.find(".summaryStatValueTitleLabel").html(cData.titleLabel).addClass('labelStyle' + cData.rank);
                item.find(".summaryStatValueRankLabel").html(cData.rankLabel).addClass('labelStyle' + cData.rank);
                item.find(".summaryStatValueOpened").html(("%s %s").format(cData.opened, 'feltárt'));
                item.find(".summaryStatValueHit").html(("%s %s").format(cData.hit, 'láda'));

                item.appendTo(statisticsItemContainer);
            }

            summaryStatistics.appendTo(statisticsContent);

            setInterval(function () {
                statisticsItemContainer.find(".statisticsOrderByMenu").prop("disabled", false);
            }, floodProtectionTime * 1000);

        }

    } else if (statType === 'myStatistics') {

        if (!$.isEmptyObject(data)) {

            let myStatistics = $(".myStatistics").clone();
            myStatistics.removeClass("template");

            myStatistics.find(".sPoint").html(("%s").format(data.point));
            myStatistics.find(".sCoin").html(("%s").format(data.coin));

            myStatistics.find(".sOpened").html(data.opened);
            myStatistics.find(".sHit").html(data.hit);

            myStatistics.appendTo(statisticsContent);
        }

    } else if (statType === 'ranks') {

        let rankList = $(".rankList").clone();
        rankList.removeClass("template");

        let tableContainer = rankList.find('.tableContainer');

        let titles = data.titles;
        let ranks = data.ranks;
        let rankLabels = data.rankLabels;
        let titleLabels = data.titleLabels;

        // TITLE TABLE
        let titleTable = $('<table/>');

        titleTable.append('<tr>' +
            '<th>Cím</th>' +
            '<th>Láda</th>' +
            '<th>Rang</th>' +
            '</tr>');

        titleTable.addClass("statisticsTitles tblTheme3");

        for (let i = 0; i < titles.length; i++) {

            let rankIndex = titles[i].rank - 1;

            titleTable.append('<tr>' +
                '<td>' + titleLabels[i] + '</td>' +
                '<td>' + titles[i].opened + '</td>' +
                '<td>' + data.rankLabels[rankIndex] + '</td>' +
                '</tr>');
        }

        tableContainer.append(titleTable);


        // RANK TABLE
        let rankTable = $('<table/>');

        rankTable.append('<tr>' +
            '<th>Rang</th>' +
            '<th>Láda</th>' +
            '<th>Helyek</th>' +
            '</tr>');

        rankTable.addClass("statisticsRanks tblTheme3");

        for (let i = 0; i < ranks.length; i++) {

            let rank = ranks[i];

            rankTable.append('<tr>' +
                '<td>' + rankLabels[i] + '</td>' +
                '<td>' + rank.hit + '</td>' +
                '<td>' + rank.opened + '</td>' +
                '</tr>');
        }

        tableContainer.append(rankTable);
        rankList.appendTo(statisticsContent);
    }

    statisticsContainer.appendTo(page);
    pageWrapper.css("display", "block");
    page.css("display", "block");

}

function updateBalance(data) {

    let balanceUl = $('.balance');

    balanceUl.find('.point').html(data.point);
    balanceUl.find('.coin').html(data.coin);
}

function openShop(userData, shopData) {


    let pageWrapper = $(".pageWrapper");
    pageWrapper.find(".titleContainer").css("display", "none");

    let page = $("#page");
    page.empty();

    let shopContainer = $(".shopContainer").clone();
    shopContainer.removeClass("template");

    shopContainer.find(".point").html(userData.stats.point);
    shopContainer.find(".coin").html(userData.stats.coin);

    let shopContent = shopContainer.find(".shopContent");

    if (!$.isEmptyObject(shopData)) {

        let shop = $(".shop").clone();
        shop.removeClass("template");


        let shopItemContainer = shop.find(".shopItemContainer");
        let itemTmp = shopItemContainer.find(".shopItem");
        shopItemContainer.removeClass("template");


        for (let i = 0; i < shopData.length; i++) {

            let sData = shopData[i];

            let item = itemTmp.clone();
            item.removeClass("template");

            item.find(".siImg").css("background-image", "url('img/item/" + sData.item + ".png')");
            item.find(".siLabel").html(sData.label);
            item.find(".siPrice").html(sData.price).addClass('currency_' + sData.currency);


            let pieceHtml = item.find(".siPiece");
            let piece = 1;

            item.find(".siMinus").click(function () {

                piece = pieceHtml.html() * 1;

                if (typeof (piece) === 'number' && piece > 1) {

                    pieceHtml.html(--piece);
                }

                return false;
            });

            item.find(".siPlus").click(function () {

                piece = pieceHtml.html() * 1;

                if (typeof (piece) === 'number') {

                    pieceHtml.html(++piece);
                }

                return false;
            });


            item.find(".siBuyBtn").click(function () {

                piece = pieceHtml.html() * 1;

                if (typeof (piece) !== 'number' || piece < 1) {
                    piece = 1;
                }

                sData.piece = piece;

                if (lastEventTime + floodProtectionTime < getTimeStamp()) {

                    lastEventTime = getTimeStamp();

                    $.post('https://eco_caching/buy', JSON.stringify(sData));
                } else {

                    ShowNotification({type: 'fail', text: floodMessage});
                }

                return false;
            });

            item.appendTo(shopItemContainer);
        }

        shop.appendTo(shopContent);
    }

    shopContainer.appendTo(page);
    pageWrapper.css("display", "block");
    page.css("display", "block");

}

// Listen for NUI Events
window.addEventListener('message', function (event) {

    let item = event.data;

    switch (item.subject) {

        // HUD
        case 'UPDATE':

            updateHud(item.value);
            updateBalance(item.value);
            break;

        case 'CLOSE_INFO':

            closeHud('.gInfo');
            closeHud('.aInfo');
            break;

        case 'GEO_INFO':

            if (item.operation === 'close') {

                closeHud('.gInfo');
            } else {

                geoInfo(item.geoData);
            }
            break;

        case 'ACTION_INFO':

            if (item.operation === 'close') {

                closeHud('.aInfo');

            } else if ($('#page').css('display') !== 'block') {

                actionInfo(item.actionData);
            }
            break;

        case 'NOTIFICATION':

            ShowNotification(item);
            break;

        case 'POPUP_NOTIFICATION':

            ShowPopupNotification(item.data);
            break;

        // PAGES
        case 'CONTROL':

            closePage();
            openControl(item.data);
            break;

        case 'SHOP':

            closePage();
            openShop(item.userData, item.shopData);
            break;

        case 'STATISTICS':

            closePage();
            openStatistics(item.data);
            break;

        case 'CLOSE_PAGE':

            closePage();
            break;
    }

});


$('.btnClose').click(function () {

    closePage();
    $.post('https://eco_caching/exit', JSON.stringify({}));
});

$(document).keyup(function (key) {

    if (key.which === 27) {

        closePage();
        $.post('https://eco_caching/exit', JSON.stringify({}));
    }
});

function orderBy(selectMenu) {

    if (lastEventTime + floodProtectionTime < getTimeStamp()) {

        lastEventTime = getTimeStamp();

        missionOrderBy = selectMenu.value;

        $.post('https://eco_caching/getAllStatistics', JSON.stringify({

            orderBy: missionOrderBy
        })).then(
            resp => {

                openStatistics(jsonParse(resp), 'allStatistics')
            }
        );

    } else {

        ShowNotification({type: 'fail', text: floodMessage});
        return false;
    }
}