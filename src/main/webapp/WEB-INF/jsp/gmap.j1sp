<%-- 
    Document   : gmap
    Created on : Feb 11, 2019, 4:27:04 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            #map {
                width: 100%;
                height: 600px;
                background-color: grey;
            }
        </style>
    </head>
    <body>
        <h3>My Google Maps Demo</h3>
        <!--The div element for the map -->
        <div id="map"></div>
    </body>
    <script type="text/javascript"
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA-ljqryRoHEtU_Ss4V7gk53Jj53xUfXlM&libraries=visualization">
    </script>    

    <script>

        if (navigator.geolocation) {
            console.log("valod");
            navigator.geolocation.getCurrentPosition(showPosition, showError,{timeout:100000});
        }

        function showError(error) {
            alert(error.message);
            switch (error.code) {
//                case error.PERMISSION_DENIED:
//                    x.innerHTML = "User denied the request for Geolocation."
//                    break;
//                case error.POSITION_UNAVAILABLE:
//                    x.innerHTML = "Location information is unavailable."
//                    break;
//                case error.TIMEOUT:
//                    x.innerHTML = "The request to get user location timed out."
//                    break;
//                case error.UNKNOWN_ERROR:
//                    x.innerHTML = "An unknown error occurred."
//                    break;
            }
        }

        function showPosition(position) {
            console.log("Latitude: " + position.coords.latitude +
                    "<br>Longitude: " + position.coords.longitude);
            
        var Yerevan = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

        map = new google.maps.Map(document.getElementById('map'), {
            center: Yerevan,
            zoom: 18,
            mapTypeId: 'satellite'
        });

        var heatmap = new google.maps.visualization.HeatmapLayer({
            data: heatmapData,
            radius: 10
        });
        heatmap.setMap(map);            
            
        }

        /* Data points defined as an array of LatLng objects */
        var heatmapData = [
            {location: new google.maps.LatLng(40.185558, 44.514880), weight: 10},
            {location: new google.maps.LatLng(40.185558, 44.514871), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514862), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514853), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514844), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514835), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514826), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514817), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514808), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514799), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514780), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514771), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514762), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514753), weight: 40},
            {location: new google.maps.LatLng(40.185558, 44.514744), weight: 40},
//            new google.maps.LatLng(40.185558, 44.514880)
        ];


    </script>

</html>