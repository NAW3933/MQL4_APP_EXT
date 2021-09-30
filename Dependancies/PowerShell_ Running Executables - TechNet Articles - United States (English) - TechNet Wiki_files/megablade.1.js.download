if (typeof Sto == "undefined") {
    Sto = {};
}

Sto.Megablade = (function () {

    function initialjQueryAndMegablade() {
        if (typeof jQuery === "undefined") {
            var js = document.createElement('script');
            js.type = "text/javascript";
            js.async = true;
            if (typeof jQueryUrl != 'undefined' && jQueryUrl != undefined && jQueryUrl.length != 0) {
                js.src = jQueryUrl;
            }
            else {
                js.src = "//ajax.aspnetcdn.com/ajax/jQuery/jquery-3.5.0.min.js";
            }
            if (js.addEventListener) {
                js.addEventListener("load", initialMegablade, false);
            } else if (js.readyState) {
                js.onreadystatechange = function () {
                    if (this.readyState == 'complete' || this.readyState == 'loaded') initialMegablade();
                };
            }
            document.getElementsByTagName("head")[0].appendChild(js);
        }
        else {
            initialMegablade();
        }
    }

    function openMenu() {
        var $bladeItems = $megablade.find(".bladeItemMenuContainer .bladeItemMenu");
        var bladeItemMenuHeight = 0;
        $bladeItems.each(function () {
            var currentHeight = $(this).outerHeight();
            if (bladeItemMenuHeight < currentHeight)
                bladeItemMenuHeight = currentHeight;
        });
        $megablade.find(".bladeItemMenuContainer").height(bladeItemMenuHeight);
        $megablade.find(".menuContainerLayoutSplashGuard").each(function () {
            var $that = $(this);
            var splashTopMargin = $that.css("margin-top").replace("px", "");
            if (splashTopMargin.length > 0) {
                $that.height(bladeItemMenuHeight - splashTopMargin * 2);
            }
        });
        if (useIFrame && iframe) {
            iframe.style.height = (bladeItemMenuHeight + 25) + 'px';
        }
    }

    function closeMenu() {
        if (useIFrame && iframe) {
            iframe.style.height = '20px';
        }
    }

    function anchorClickHandler(that, text) {
        if (useIFrame) {
            parent.location = $(that).attr('href');
            return false;
        }
        return true;
    }

    var useIFrame = false;
    var iframe = null;
    var $megablade = null;

    function initBrowserDetect() {
        jQuery.uaMatch = function (ua) {
            ua = ua.toLowerCase();

            var match = /(chrome)[ \/]([\w.]+)/.exec(ua) ||
                /(webkit)[ \/]([\w.]+)/.exec(ua) ||
                /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) ||
                /(msie) ([\w.]+)/.exec(ua) ||
                ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) ||
                [];

            return {
                browser: match[1] || "",
                version: match[2] || "0"
            };
        };

        // Don't clobber any existing jQuery.browser in case it's different
        if (!jQuery.browser) {
            matched = jQuery.uaMatch(navigator.userAgent);
            browser = {};

            if (matched.browser) {
                browser[matched.browser] = true;
                browser.version = matched.version;
            }

            // Chrome is Webkit, but Webkit is also Safari.
            if (browser.chrome) {
                browser.webkit = true;
            } else if (browser.webkit) {
                browser.safari = true;
            }

            jQuery.browser = browser;
        }
    }

    function initialMegablade() {
        $(document).ready(function () {
            initBrowserDetect();
            var $megabladeIframe = $("iframe#megabladeIframe");
            if ($megabladeIframe.length > 0) {
                var $iframeContents = $("div#iframeContents");
                if ($iframeContents.length > 0) {
                    if ($iframeContents.html().length == 0) return;
                    $megabladeIframe.contents().find("body")
                        .css('background-color', 'transparent')
                        .css('margin', '0px')
                        .append($iframeContents.html());
                    $iframeContents.empty();
                }
                useIFrame = true;
                iframe = $megabladeIframe[0];
                iframe.style.display = '';
                $megablade = $megabladeIframe.contents().find("#megabladeContainer");

            }
            else {
                $megablade = $("#megabladeContainer");
            }
            var $megabladeMenuContainer = $megablade.find('div.bladeItemMenuContainer');
            $megablade.show();
            // fix accessibility bug https://ceapex.visualstudio.com/Engineering/_workitems/edit/114658/
            // When focus is on last link present in the dropdown, If we press tab focus should not point to the controls which are behind dropdown. it will return the first link in the expanded list items
            $megablade.find("div.bladeItemMenu").each(function () {
                $(this).find("a:last").blur(function () {
                    $(this).parents("div.bladeItemMenu").find("a:first").focus();
                });
            });
            // fix accessibility bug https://ceapex.visualstudio.com/Engineering/_workitems/edit/114628/
            // when the focus is on the first of expanded list items, click shift Tab should go to the top navigation 
            $megablade.on('keydown', function (event) {
                if (event.shiftKey && event.keyCode == 9) {
                    var aLink = $(document.activeElement);
                    if (aLink.is(aLink.parents(".bladeItemMenu").find("a:first"))) {
                        var val = aLink.parents(".bladeItemMenu").attr("data-value");
                        $megablade.find("li[data-value=" + val + "] a.label").focus();
                        return false;
                    }
                }
            });
            // click escape key close menu
            $megablade.on('keyup', function (event) {
                switch (event.keyCode) {
                    // Escape key
                    case 27:
                        resetBladeItems();
                        $megablade.find("li.bladeItem > a").attr("aria-expanded", "false");
                        $megablade.find("div.bladeItemMenu").hide();
                        var aLink = $(document.activeElement);
                        var val = aLink.parents(".bladeItemMenu").attr("data-value");
                        if (val) {
                            $megablade.find("li[data-value=" + val + "] a.label").focus();
                        }
                        break;
                }
            });
            $megablade.find('div.menuContainerLayout')
                .delegate('a', 'click', function () { anchorClickHandler(this, $(this).parents('div.bladeItemMenu').attr("data-value")); });
            $megablade.find("ul#megabladeItems")
                .delegate('li.Logo a', 'click', function () { anchorClickHandler(this, 'TechNet'); })
                .delegate('li.bladeItemWithMenu', 'click', function () {
                    var val = $(this).attr("data-value");
                    if (omnitureTracking) {
                        if (useIFrame && (typeof parent.t_omni_utils != "undefined")) {
                            parent.t_omni_utils.omniModTracking(true, "megablade", val, val, 0, val, "");
                        }
                        else if (typeof t_omni_utils != "undefined") {
                            t_omni_utils.omniModTracking(true, "megablade", val, val, 0, val, "");
                        }
                    }

                    resetBladeItems();
                    var $selected = $megablade.find("div[data-value=" + val + "]");
                    $selected.siblings().hide();

                    var containerCenter = $megablade.find("#megabladeContainerCenter");
                    if ($("html").attr("dir") != "rtl") {
                        $megabladeMenuContainer.css("left", containerCenter.offset().left + "px");
                    } else {
                        $megabladeMenuContainer.css("right", ($(document).width() - containerCenter.width()) / 2 + 'px');
                    }

                    $selected.toggle();
                    // fix accessibility bug https://ceapex.visualstudio.com/Engineering/_workitems/edit/114628/
                    // When the top navigation expandable buttons (Products, IT Resources, Downloads, Training and Support) are expanded, Focus should go to the expanded list items
                    $selected.find("li > a:first").focus();
                    if ($selected.is(':visible')) {
                        $(this).find(".caret").addClass("caretActive");
                        $(this).addClass("bladeItemExpanded");
                        $(this).find("a").attr("aria-expanded", "true");
                        openMenu();
                    }
                    else {
                        $(this).find(".caret").removeClass("caretActive");
                        $(this).removeClass("bladeItemExpanded");
                        $(this).find("a").attr("aria-expanded", "false");
                        closeMenu();
                    }

                    $(this).addClass("bladeItemActive");
                })
                .delegate('li.bladeItemWithLink a', 'click', function () { anchorClickHandler(this, $(this).text()); })
                .delegate('li.bladeItem', 'hover', function () { $(this).toggleClass("bladeItemActive"); });
            $megablade.find("li a.label").focus(function () { $('li.bladeItem').removeClass('bladeItemActive'); $(this).parent().addClass('bladeItemActive'); });
            $megablade.find("li a.label").blur(function () { $(this).parent().removeClass('bladeItemActive'); });

            $megablade.find("div.bladeItemMenu").mouseleave(function (e) {
                if ($.browser.mozilla && !(e.toElement || e.relatedTarget) && e.eventPhase == 3) {
                    return false;
                }
                if (e.pageY < 20) {
                    return false;
                }
                resetBladeItems();
                $(this).hide();
            }).mouseenter(function () {
                $megablade.find("li.bladeItem[data-value=" + $(this).data("value") + "]").addClass('bladeItemExpanded');
            });

            $megablade.find('img[data-src]').each(function () {
                var $img = $(this);
                $img.attr("src", $img.attr('data-src')).removeAttr('data-src');
            });
        });
    }

    function resetBladeItems() {
        $megablade.find("span.caret").removeClass("caretActive");
        $megablade.find("li.bladeItem").removeClass('bladeItemExpanded bladeItemActive');
        closeMenu();
    }

    return {
        initialjQueryAndMegablade: initialjQueryAndMegablade
    };
})();

Sto.Megablade.initialjQueryAndMegablade();
// SIG // Begin signature block
// SIG // MIInNgYJKoZIhvcNAQcCoIInJzCCJyMCAQExDzANBglg
// SIG // hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
// SIG // BgEEAYI3AgEeMCQCAQEEEBDgyQbOONQRoqMAEEvTUJAC
// SIG // AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
// SIG // 2cMXF9UXfFuRS3vSYB3il84Y6BdXhiU6G3NxhTKZKMGg
// SIG // ghFlMIIIdzCCB1+gAwIBAgITNgAAATl4xjn15Xcn6gAB
// SIG // AAABOTANBgkqhkiG9w0BAQsFADBBMRMwEQYKCZImiZPy
// SIG // LGQBGRYDR0JMMRMwEQYKCZImiZPyLGQBGRYDQU1FMRUw
// SIG // EwYDVQQDEwxBTUUgQ1MgQ0EgMDEwHhcNMjAxMDIxMjAz
// SIG // OTA2WhcNMjEwOTE1MjE0MzAzWjAkMSIwIAYDVQQDExlN
// SIG // aWNyb3NvZnQgQXp1cmUgQ29kZSBTaWduMIIBIjANBgkq
// SIG // hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr7X+kRvV9WxV
// SIG // y0Dsy7gNOpOYAYYsy1kN/5upyCjsKDbLvTfrPcrfmRka
// SIG // W2Ww7QZrQHqIt3Nlyvb39Md7Kt9hljz7/qcemu7uebUP
// SIG // ZauHr1+kDcT4ax/vpbZVLbIolZlfd+P/heQf+9bCdTca
// SIG // /PTrBMVdW+RMuy4ipBMMaU0cZTslF3+DokL0w8xtCOwL
// SIG // HieEcTstt7S54fNuvKZLnGNj20ixWKESBtWRjYHIXKay
// SIG // /rokS7gs+L2V34nUKFrrN04WPPpmLpQ/AGkOWbZ7sM0h
// SIG // 7c8WJv4Ojnkg7H+MRXqdA2CwN8zYijuAr5szUYyW3INQ
// SIG // ZuzqQ3vwki0lhuWqKlvl+QIDAQABo4IFgzCCBX8wKQYJ
// SIG // KwYBBAGCNxUKBBwwGjAMBgorBgEEAYI3WwEBMAoGCCsG
// SIG // AQUFBwMDMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcV
// SIG // CIaQ4w2E1bR4hPGLPoWb3RbOnRKBYIPdzWaGlIwyAgFk
// SIG // AgEMMIICdgYIKwYBBQUHAQEEggJoMIICZDBiBggrBgEF
// SIG // BQcwAoZWaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3Br
// SIG // aWluZnJhL0NlcnRzL0JZMlBLSUNTQ0EwMS5BTUUuR0JM
// SIG // X0FNRSUyMENTJTIwQ0ElMjAwMSgxKS5jcnQwUgYIKwYB
// SIG // BQUHMAKGRmh0dHA6Ly9jcmwxLmFtZS5nYmwvYWlhL0JZ
// SIG // MlBLSUNTQ0EwMS5BTUUuR0JMX0FNRSUyMENTJTIwQ0El
// SIG // MjAwMSgxKS5jcnQwUgYIKwYBBQUHMAKGRmh0dHA6Ly9j
// SIG // cmwyLmFtZS5nYmwvYWlhL0JZMlBLSUNTQ0EwMS5BTUUu
// SIG // R0JMX0FNRSUyMENTJTIwQ0ElMjAwMSgxKS5jcnQwUgYI
// SIG // KwYBBQUHMAKGRmh0dHA6Ly9jcmwzLmFtZS5nYmwvYWlh
// SIG // L0JZMlBLSUNTQ0EwMS5BTUUuR0JMX0FNRSUyMENTJTIw
// SIG // Q0ElMjAwMSgxKS5jcnQwUgYIKwYBBQUHMAKGRmh0dHA6
// SIG // Ly9jcmw0LmFtZS5nYmwvYWlhL0JZMlBLSUNTQ0EwMS5B
// SIG // TUUuR0JMX0FNRSUyMENTJTIwQ0ElMjAwMSgxKS5jcnQw
// SIG // ga0GCCsGAQUFBzAChoGgbGRhcDovLy9DTj1BTUUlMjBD
// SIG // UyUyMENBJTIwMDEsQ049QUlBLENOPVB1YmxpYyUyMEtl
// SIG // eSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZp
// SIG // Z3VyYXRpb24sREM9QU1FLERDPUdCTD9jQUNlcnRpZmlj
// SIG // YXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlv
// SIG // bkF1dGhvcml0eTAdBgNVHQ4EFgQUUGrH1hbhlmeE4x4+
// SIG // xNBviWC5XYMwDgYDVR0PAQH/BAQDAgeAMFAGA1UdEQRJ
// SIG // MEekRTBDMSkwJwYDVQQLEyBNaWNyb3NvZnQgT3BlcmF0
// SIG // aW9ucyBQdWVydG8gUmljbzEWMBQGA1UEBRMNMjM2MTY3
// SIG // KzQ2MjUxNjCCAdQGA1UdHwSCAcswggHHMIIBw6CCAb+g
// SIG // ggG7hjxodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtp
// SIG // aW5mcmEvQ1JML0FNRSUyMENTJTIwQ0ElMjAwMS5jcmyG
// SIG // Lmh0dHA6Ly9jcmwxLmFtZS5nYmwvY3JsL0FNRSUyMENT
// SIG // JTIwQ0ElMjAwMS5jcmyGLmh0dHA6Ly9jcmwyLmFtZS5n
// SIG // YmwvY3JsL0FNRSUyMENTJTIwQ0ElMjAwMS5jcmyGLmh0
// SIG // dHA6Ly9jcmwzLmFtZS5nYmwvY3JsL0FNRSUyMENTJTIw
// SIG // Q0ElMjAwMS5jcmyGLmh0dHA6Ly9jcmw0LmFtZS5nYmwv
// SIG // Y3JsL0FNRSUyMENTJTIwQ0ElMjAwMS5jcmyGgbpsZGFw
// SIG // Oi8vL0NOPUFNRSUyMENTJTIwQ0ElMjAwMSxDTj1CWTJQ
// SIG // S0lDU0NBMDEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUy
// SIG // MFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3Vy
// SIG // YXRpb24sREM9QU1FLERDPUdCTD9jZXJ0aWZpY2F0ZVJl
// SIG // dm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JM
// SIG // RGlzdHJpYnV0aW9uUG9pbnQwHwYDVR0jBBgwFoAUG2ai
// SIG // Gfyb66XahI8YmOkQpMN7kr0wHwYDVR0lBBgwFgYKKwYB
// SIG // BAGCN1sBAQYIKwYBBQUHAwMwDQYJKoZIhvcNAQELBQAD
// SIG // ggEBAKxTTHwCUra3f91eISJ03YxKPwi2AGPGF/36BgJs
// SIG // pOja4xMd7hTdLCZkd6kdIgYIEt0gYlIuKGfl5PPg41Z5
// SIG // yRZ/RYZrv5AdsE+GSo442XlkTj3E7FJ0YLNfjoSk1m19
// SIG // hJ4PKB9wqtKkfS2jk/xEuRI3ffEtY6ulmfAfCnTR4NHf
// SIG // lRgLcLbPhN7rvDJFDOa1LpJjx1uwQvLbZoCnl2YiIi1e
// SIG // E9Ss8QTDDYNJWO4hW0OX5I+YS2tRNFr7BjHDBjjMEVFc
// SIG // FcJehfDi/GlGOYu7aQLs+eF1UuFtYKz8kyQ2ntagdfR+
// SIG // Sb6k8DzzZt9CaxRqUf1/0hkIUTrKA+FdbbwifLQwggjm
// SIG // MIIGzqADAgECAhMfAAAAFLTFH8bygL5xAAAAAAAUMA0G
// SIG // CSqGSIb3DQEBCwUAMDwxEzARBgoJkiaJk/IsZAEZFgNH
// SIG // QkwxEzARBgoJkiaJk/IsZAEZFgNBTUUxEDAOBgNVBAMT
// SIG // B2FtZXJvb3QwHhcNMTYwOTE1MjEzMzAzWhcNMjEwOTE1
// SIG // MjE0MzAzWjBBMRMwEQYKCZImiZPyLGQBGRYDR0JMMRMw
// SIG // EQYKCZImiZPyLGQBGRYDQU1FMRUwEwYDVQQDEwxBTUUg
// SIG // Q1MgQ0EgMDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
// SIG // ggEKAoIBAQDVV4EC1vn60PcbgLndN80k3GZh/OGJcq0p
// SIG // DNIbG5q/rrRtNLVUR4MONKcWGyaeVvoaQ8J5iYInBaBk
// SIG // az7ehYnzJp3f/9Wg/31tcbxrPNMmZPY8UzXIrFRdQmCL
// SIG // sj3LcLiWX8BN8HBsYZFcP7Y92R2VWnEpbN40Q9XBsK3F
// SIG // aNSEevoRzL1Ho7beP7b9FJlKB/Nhy0PMNaE1/Q+8Y9+W
// SIG // bfU9KTj6jNxrffv87O7T6doMqDmL/MUeF9IlmSrl088b
// SIG // oLzAOt2LAeHobkgasx3ZBeea8R+O2k+oT4bwx5ZuzNpb
// SIG // GXESNAlALo8HCf7xC3hWqVzRqbdnd8HDyTNG6c6zwyf/
// SIG // AgMBAAGjggTaMIIE1jAQBgkrBgEEAYI3FQEEAwIBATAj
// SIG // BgkrBgEEAYI3FQIEFgQUkfwzzkKe9pPm4n1U1wgYu7jX
// SIG // cWUwHQYDVR0OBBYEFBtmohn8m+ul2oSPGJjpEKTDe5K9
// SIG // MIIBBAYDVR0lBIH8MIH5BgcrBgEFAgMFBggrBgEFBQcD
// SIG // AQYIKwYBBQUHAwIGCisGAQQBgjcUAgEGCSsGAQQBgjcV
// SIG // BgYKKwYBBAGCNwoDDAYJKwYBBAGCNxUGBggrBgEFBQcD
// SIG // CQYIKwYBBQUIAgIGCisGAQQBgjdAAQEGCysGAQQBgjcK
// SIG // AwQBBgorBgEEAYI3CgMEBgkrBgEEAYI3FQUGCisGAQQB
// SIG // gjcUAgIGCisGAQQBgjcUAgMGCCsGAQUFBwMDBgorBgEE
// SIG // AYI3WwEBBgorBgEEAYI3WwIBBgorBgEEAYI3WwMBBgor
// SIG // BgEEAYI3WwUBBgorBgEEAYI3WwQBBgorBgEEAYI3WwQC
// SIG // MBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
// SIG // DwQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB8GA1Ud
// SIG // IwQYMBaAFCleUV5krjS566ycDaeMdQHRCQsoMIIBaAYD
// SIG // VR0fBIIBXzCCAVswggFXoIIBU6CCAU+GI2h0dHA6Ly9j
// SIG // cmwxLmFtZS5nYmwvY3JsL2FtZXJvb3QuY3JshjFodHRw
// SIG // Oi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpaW5mcmEvY3Js
// SIG // L2FtZXJvb3QuY3JshiNodHRwOi8vY3JsMi5hbWUuZ2Js
// SIG // L2NybC9hbWVyb290LmNybIYjaHR0cDovL2NybDMuYW1l
// SIG // LmdibC9jcmwvYW1lcm9vdC5jcmyGgapsZGFwOi8vL0NO
// SIG // PWFtZXJvb3QsQ049QU1FUk9PVCxDTj1DRFAsQ049UHVi
// SIG // bGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
// SIG // Q049Q29uZmlndXJhdGlvbixEQz1BTUUsREM9R0JMP2Nl
// SIG // cnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmpl
// SIG // Y3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCCAasG
// SIG // CCsGAQUFBwEBBIIBnTCCAZkwNwYIKwYBBQUHMAKGK2h0
// SIG // dHA6Ly9jcmwxLmFtZS5nYmwvYWlhL0FNRVJPT1RfYW1l
// SIG // cm9vdC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jcmwu
// SIG // bWljcm9zb2Z0LmNvbS9wa2lpbmZyYS9jZXJ0cy9BTUVS
// SIG // T09UX2FtZXJvb3QuY3J0MDcGCCsGAQUFBzAChitodHRw
// SIG // Oi8vY3JsMi5hbWUuZ2JsL2FpYS9BTUVST09UX2FtZXJv
// SIG // b3QuY3J0MDcGCCsGAQUFBzAChitodHRwOi8vY3JsMy5h
// SIG // bWUuZ2JsL2FpYS9BTUVST09UX2FtZXJvb3QuY3J0MIGi
// SIG // BggrBgEFBQcwAoaBlWxkYXA6Ly8vQ049YW1lcm9vdCxD
// SIG // Tj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMs
// SIG // Q049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1B
// SIG // TUUsREM9R0JMP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmpl
// SIG // Y3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MA0G
// SIG // CSqGSIb3DQEBCwUAA4ICAQAot0qGmo8fpAFozcIA6pCL
// SIG // ygDhZB5ktbdA5c2ZabtQDTXwNARrXJOoRBu4Pk6VHVa7
// SIG // 8Xbz0OZc1N2xkzgZMoRpl6EiJVoygu8Qm27mHoJPJ9ao
// SIG // 9603I4mpHWwaqh3RfCfn8b/NxNhLGfkrc3wp2VwOtkAj
// SIG // J+rfJoQlgcacD14n9/VGt9smB6j9ECEgJy0443B+mwFd
// SIG // yCJO5OaUP+TQOqiC/MmA+r0Y6QjJf93GTsiQ/Nf+fjzi
// SIG // zTMdHggpTnxTcbWg9JCZnk4cC+AdoQBKR03kTbQfIm/n
// SIG // M3t275BjTx8j5UhyLqlqAt9cdhpNfdkn8xQz1dT6hTnL
// SIG // iowvNOPUkgbQtV+4crzKgHuHaKfJN7tufqHYbw3FnTZo
// SIG // pnTFr6f8mehco2xpU8bVKhO4i0yxdXmlC0hKGwGqdeoW
// SIG // NjdskyUyEih8xyOK47BEJb6mtn4+hi8TY/4wvuCzcvrk
// SIG // Zn0F0oXd9JbdO+ak66M9DbevNKV71YbEUnTZ81toX0Lt
// SIG // sbji4PMyhlTg/669BoHsoTg4yoC9hh8XLW2/V2lUg3+q
// SIG // HHQf/2g2I4mm5lnf1mJsu30NduyrmrDIeZ0ldqKzHAHn
// SIG // fAmyFSNzWLvrGoU9Q0ZvwRlDdoUqXbD0Hju98GL6dTew
// SIG // 3S2mcs+17DgsdargsEPm6I1lUE5iixnoEqFKWTX5j/TL
// SIG // UjGCFSkwghUlAgEBMFgwQTETMBEGCgmSJomT8ixkARkW
// SIG // A0dCTDETMBEGCgmSJomT8ixkARkWA0FNRTEVMBMGA1UE
// SIG // AxMMQU1FIENTIENBIDAxAhM2AAABOXjGOfXldyfqAAEA
// SIG // AAE5MA0GCWCGSAFlAwQCAQUAoIGuMBkGCSqGSIb3DQEJ
// SIG // AzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAM
// SIG // BgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCD8OTLS
// SIG // bG/htCZaX+PM68O0dV3qc9PuQ/5IXVIjMe+Z9TBCBgor
// SIG // BgEEAYI3AgEMMTQwMqAUgBIATQBpAGMAcgBvAHMAbwBm
// SIG // AHShGoAYaHR0cDovL3d3dy5taWNyb3NvZnQuY29tMA0G
// SIG // CSqGSIb3DQEBAQUABIIBAJ+acZheo0iXBJCVc0EXjM26
// SIG // dqz5lJ9Snq1YnlkkgL9McosVaTkj0D1bPIi6WGvaz3Kv
// SIG // PCzQzoawvWYNAZ5gpTmwiG6dkIqGXL/DbOw9eRNEd2gY
// SIG // J3ucglWfIyoTMWVDa8QcBMicReRGcaFOVXwqn1AfiFe8
// SIG // gd2s44H+OpO0RklUMmVrN/V/jO1NufBptQypQsPDyAF3
// SIG // 9J5tv5r+y+wsDOzmWtq6Kw8yDG+FNbpX/S1PeHNHxuCe
// SIG // i7ZYcJs3bov4iKOcuy/WlykzAhtnzGmsMxtqPGuwM6JS
// SIG // E6z0TP8SG9gBpK04qB33wVuvSIx+y7yWezOoVoUGcVP3
// SIG // crkxYHIGPLChghLxMIIS7QYKKwYBBAGCNwMDATGCEt0w
// SIG // ghLZBgkqhkiG9w0BBwKgghLKMIISxgIBAzEPMA0GCWCG
// SIG // SAFlAwQCAQUAMIIBVQYLKoZIhvcNAQkQAQSgggFEBIIB
// SIG // QDCCATwCAQEGCisGAQQBhFkKAwEwMTANBglghkgBZQME
// SIG // AgEFAAQgpyBjy8tkLVvbfhw76Bgq42It+llMVJv4B0ll
// SIG // 7pbky0sCBmEes2tUDRgTMjAyMTA5MDkwODUwMzguNzI3
// SIG // WjAEgAIB9KCB1KSB0TCBzjELMAkGA1UEBhMCVVMxEzAR
// SIG // BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
// SIG // bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
// SIG // bjEpMCcGA1UECxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMg
// SIG // UHVlcnRvIFJpY28xJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
// SIG // RVNOOkY3N0YtRTM1Ni01QkFFMSUwIwYDVQQDExxNaWNy
// SIG // b3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIORDCCBPUw
// SIG // ggPdoAMCAQICEzMAAAFenSnHX4cFoeoAAAAAAV4wDQYJ
// SIG // KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
// SIG // BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
// SIG // HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEm
// SIG // MCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
// SIG // IDIwMTAwHhcNMjEwMTE0MTkwMjE5WhcNMjIwNDExMTkw
// SIG // MjE5WjCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
// SIG // c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
// SIG // BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEpMCcGA1UE
// SIG // CxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJp
// SIG // Y28xJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkY3N0Yt
// SIG // RTM1Ni01QkFFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGlt
// SIG // ZS1TdGFtcCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEF
// SIG // AAOCAQ8AMIIBCgKCAQEAmtMjg5B6GfegqnbO6HpY/ZmJ
// SIG // v8PHD+yst57JNv153s9f58uDvMEDTKXqK8XafqVq4Yfx
// SIG // bsQHBE8S/tkJJfBeBhnoYZofxpT46sNcBtzgFdM7lecs
// SIG // bBJtrJ71Hb65Ad0ImZoy3P+UQFZQrnG8eiPRNStc5l1n
// SIG // ++/tOoxYDiHUBPXD8kFHiQe1XWLwpZ2VD51lf+A0ekDv
// SIG // Yigug6akiZsZHNwZDhnYrOrh4wH3CNoVFXUkX/DPWEsU
// SIG // iMa2VTd4aNEGIEQRUjtQQwxK8jisr4J8sAhmdQu7tLOU
// SIG // h+pJTdHSlI1RqHClZ0KIHp8rMir3hn73zzyahC6j3lEA
// SIG // +bMdBbUwjQIDAQABo4IBGzCCARcwHQYDVR0OBBYEFKpy
// SIG // fLoN3UvlVMIQAJ7OVHjV+B8rMB8GA1UdIwQYMBaAFNVj
// SIG // OlyKMZDzQ3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJ
// SIG // oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kv
// SIG // Y3JsL3Byb2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3
// SIG // LTAxLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUH
// SIG // MAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kv
// SIG // Y2VydHMvTWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0
// SIG // MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUH
// SIG // AwgwDQYJKoZIhvcNAQELBQADggEBAH8h/FmExiQEypGZ
// SIG // eeH9WK3ht/HKKgCWvscnVcNIdMi9HAMPU8avS6lkT++u
// SIG // sj9A3/VaLq8NwqacnavtePqlZk5mpz0Gn64G+k9q6W57
// SIG // iy27dOopNz0W7YrmJty2kXigc99n4gp4KGin4yT2Ds3m
// SIG // WUfO/RoIOJozTDZoBPeuPdAdBLyKOdDn+qG3PCjUChSd
// SIG // XXLa6tbBflod1TNqh4Amu+d/Z57z0p/jJyOPJp80lJSn
// SIG // +ppcGVuMy73S825smy11LE62/BzF54c/plphtOXZw6Vr
// SIG // hyiSI9T4FSMhkD+38hl9ihrMwaYG0tYUll0L0thZaYsu
// SIG // w0nZbbWqR5JKkQDDimYwggZxMIIEWaADAgECAgphCYEq
// SIG // AAAAAAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQG
// SIG // EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
// SIG // BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
// SIG // cnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9v
// SIG // dCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0x
// SIG // MDA3MDEyMTM2NTVaFw0yNTA3MDEyMTQ2NTVaMHwxCzAJ
// SIG // BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
// SIG // DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
// SIG // ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
// SIG // dCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG
// SIG // 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwT
// SIG // l/X6f2mUa3RUENWlCgCChfvtfGhLLF/Fw+Vhwna3PmYr
// SIG // W/AVUycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRUQwzX
// SIG // Tbg4CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJY
// SIG // R4YyhB50YWeRX4FUsc+TTJLBxKZd0WETbijGGvmGgLvf
// SIG // YfxGwScdJGcSchohiq9LZIlQYrFd/XcfPfBXday9ikJN
// SIG // QFHRD5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDa
// SIG // TgaRtogINeh4HLDpmc085y9Euqf03GS9pAHBIAmTeM38
// SIG // vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCCAeIwEAYJKwYB
// SIG // BAGCNxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8
// SIG // RhvFM2hahW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
// SIG // QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
// SIG // MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjE
// SIG // MFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWlj
// SIG // cm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jv
// SIG // b0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcB
// SIG // AQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWlj
// SIG // cm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0
// SIG // XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUwgZIw
// SIG // gY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0
// SIG // cDovL3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQ
// SIG // Uy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBM
// SIG // AGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQA
// SIG // ZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEA
// SIG // B+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1Mb7PBeKp/vpX
// SIG // bRkws8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7
// SIG // uVOMzPRgEop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMiv
// SIG // v3/Gf/I3fVo/HPKZeUqRUgCvOA8X9S95gWXZqbVr5MfO
// SIG // 9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v
// SIG // /rbljjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZ
// SIG // SnFjnXshbcOco6I8+n99lmqQeKZt0uGc+R38ONiU9Mal
// SIG // CpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ou
// SIG // OVd2onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7
// SIG // cQnfXXSYIghh2rBQHm+98eEA3+cxB6STOvdlR3jo+KhI
// SIG // q/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUBHoD7
// SIG // G4kqVDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch
// SIG // 98isTtoouLGp25ayp0Kiyc8ZQU3ghvkqmqMRZjDTu3Qy
// SIG // S99je/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXjad5XwdHe
// SIG // MMD9zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzV
// SIG // s341Hgi62jbb01+P3nSISRKhggLSMIICOwIBATCB/KGB
// SIG // 1KSB0TCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
// SIG // c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
// SIG // BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEpMCcGA1UE
// SIG // CxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJp
// SIG // Y28xJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkY3N0Yt
// SIG // RTM1Ni01QkFFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGlt
// SIG // ZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQBW
// SIG // SY9X/yFlVL0XNu2hfbHdnbFjKqCBgzCBgKR+MHwxCzAJ
// SIG // BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
// SIG // DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
// SIG // ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
// SIG // dCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEB
// SIG // BQUAAgUA5OQ4JzAiGA8yMDIxMDkwOTExMzcxMVoYDzIw
// SIG // MjEwOTEwMTEzNzExWjB3MD0GCisGAQQBhFkKBAExLzAt
// SIG // MAoCBQDk5DgnAgEAMAoCAQACAiSQAgH/MAcCAQACAhFY
// SIG // MAoCBQDk5YmnAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwG
// SIG // CisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMB
// SIG // hqAwDQYJKoZIhvcNAQEFBQADgYEADb7ESU/LCmXz3S8H
// SIG // eQXpuLfwhMPb554ETlxmPDLh1uhqHVdZ/Ax7KC2Bi65B
// SIG // t09STi/V2n56sbbAz4bOg+0KHrmx1PCVFCzt/G7rlxBz
// SIG // EHsvADRsYkiN5a1VwTIVdJ5/t9ArtSowXyVu2iI1fVYf
// SIG // bwOsznasDsUjy3DUG8X8z2QxggMNMIIDCQIBATCBkzB8
// SIG // MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
// SIG // bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
// SIG // cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
// SIG // b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAV6d
// SIG // KcdfhwWh6gAAAAABXjANBglghkgBZQMEAgEFAKCCAUow
// SIG // GgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqG
// SIG // SIb3DQEJBDEiBCC/uATl0+MJSIjMIMVT37VW8jBdxJH/
// SIG // xlF067zrYc1klzCB+gYLKoZIhvcNAQkQAi8xgeowgecw
// SIG // geQwgb0EIH7lhOyU1JeO4H7mZANMpGQzumuR7CFed69e
// SIG // ku/xEtPiMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzAR
// SIG // BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
// SIG // bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
// SIG // bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
// SIG // UENBIDIwMTACEzMAAAFenSnHX4cFoeoAAAAAAV4wIgQg
// SIG // qh2yUK/td6LKdlYJF60h6oABXtryLxe6j1hA40UGWGgw
// SIG // DQYJKoZIhvcNAQELBQAEggEAIJcc1/ot0vyppuOOcwsC
// SIG // xHYBhlCaZOjga9IJlLx5ia46vG9fJvLh2ukhIxbv6LTg
// SIG // 8P94XpDFg1SQFIaFKv/h22tl707CyNZ+xAaTlf78jHFA
// SIG // /SjRFHX0VNixZh57pdA6gvhlw0nZcww1HGBB/glIIASk
// SIG // xVqxQT+qKbBxJKtNz2dzSwpooXTMSVfJ2GpLnBA0Ej08
// SIG // Dk3CwCYOGjIP294oX3Gcilca3uV7VMc3c1B10gRmGvpl
// SIG // 0A0M4gQRrlb/lvRS0QFVp5cPXWaLEGBGnXgiECXZNlYe
// SIG // hVqyibmAK9wrQe6L9z/fdxRf3/OO7Dz2AIw0rSD8VRh8
// SIG // YE9iwL9mZ9EYfg==
// SIG // End signature block
