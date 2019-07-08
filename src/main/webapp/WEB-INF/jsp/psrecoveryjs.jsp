<%-- 
    Document   : signupjs
    Created on : May 24, 2019, 04:32:29 PM
    Author     : vahan
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="<c:url value="/assets/dist/particles.min.js?v=${version}"/>"></script>
<c:if test="${dashProp.captchaOn eq 'true'}" >
    <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit"
        async defer>
    </script>
    <script>
    var onloadCallback = function () {        
        grecaptcha.render('recaptcha', {
          'sitekey' : '${dashProp.captchaSiteKey}'      
        });        
    };
    </script>
</c:if>
<script>
    $(document).ready(function () {
//        $(".select2_country").select2({
//            placeholder: "Select a Country",
//            allowClear: true
//        });
        $(".select2_tz").val(moment.tz.guess());
//        $(".select2_tz").select2({
//            placeholder: "Select a TimeZone",
//            allowClear: true
//        });
        var particlejson = {
            "particles": {
                "number": {
                    "value": 50,
                    "density": {
                        "enable": true,
                        "value_area": 900
                    }
                },
                "color": {
                    "value": "#e5e5e5"
                },
                "shape": {
                    "type": "circle",
                    "stroke": {
                        "width": 0,
                        "color": "#000000"
                    },
                    "polygon": {
                        "nb_sides": 3
                    },
                    "image": {
                        "src": "img/github.svg",
                        "width": 100,
                        "height": 100
                    }
                },
                "opacity": {
                    "value": 1,
                    "random": true,
                    "anim": {
                        "enable": false,
                        "speed": 1,
                        "opacity_min": 0.1,
                        "sync": false
                    }
                },
                "size": {
                    "value": 4,
                    "random": true,
                    "anim": {
                        "enable": false,
                        "speed": 20,
                        "size_min": 0.1,
                        "sync": false
                    }
                },
                "line_linked": {
                    "enable": true,
                    "distance": 150,
                    "color": "#e5e5e5",
                    "opacity": 1,
                    "width": 2
                },
                "move": {
                    "enable": true,
                    "speed": 2,
                    "direction": "none",
                    "random": true,
                    "straight": false,
                    "out_mode": "out",
                    "bounce": false,
                    "attract": {
                        "enable": false,
                        "rotateX": 600,
                        "rotateY": 1763
                    }
                }
            },
            "interactivity": {
                "detect_on": "canvas",
                "events": {
                    "onhover": {
                        "enable": false,
                        "mode": "grab"
                    },
                    "onclick": {
                        "enable": false,
                        "mode": "push"
                    },
                    "resize": true
                },
                "modes": {
                    "grab": {
                        "distance": 400,
                        "line_linked": {
                            "opacity": 1
                        }
                    },
                    "bubble": {
                        "distance": 400,
                        "size": 40,
                        "duration": 2,
                        "opacity": 8,
                        "speed": 3
                    },
                    "repulse": {
                        "distance": 200,
                        "duration": 0.4
                    },
                    "push": {
                        "particles_nb": 4
                    },
                    "remove": {
                        "particles_nb": 2
                    }
                }
            },
            "retina_detect": false
        };
        particlesJS('main', particlejson);
        if (getParameterByName("invalidconfirmcode")!==null)
        {
            $("#confirmError").modal('show');            
        }
    }
    );
</script>