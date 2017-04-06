<%-- 
    Document   : loginjs
    Created on : Apr 4, 2017, 4:31:01 PM
    Author     : vahan
--%>
<script src='https://cdnjs.cloudflare.com/ajax/libs/three.js/r68/three.min.js'></script>
<script>
    var xRows = 40;
    var zRows = 40;
    var cubeSize = 600;
    var cubeGap = 50;
    var cubeRow = cubeSize + cubeGap;
    var stageWidth = $(window).width();
    var stageHeight = $(window).height();
    var container = document.createElement('div');
    document.body.prepend(container);

    var camera = new THREE.PerspectiveCamera(55, stageWidth / stageHeight, 1, 20000);
    camera.position.y = 5000;
    camera.lookAt(new THREE.Vector3(0, 0, 0));

    var scene = new THREE.Scene();
    scene.fog = new THREE.Fog(0x000000, 5000, 10000);

    var pointLight = new THREE.PointLight(0x8ad29c);
//    var pointLight = new THREE.PointLight(0x0275d8);
    pointLight.intensity = 2;
    pointLight.position.x = 3000;
    pointLight.position.y = 2500;
    pointLight.position.z = 1000;
    scene.add(pointLight);

    group = new THREE.Object3D();
    scene.add(group);

    var cubes = [];

    var halfXRows = (cubeRow * -xRows / 2);
    var halfZRows = (cubeRow * -zRows / 2);

    var renderer = new THREE.WebGLRenderer();
//    renderer.setClearColor (0x0275d8, 10);
//    renderer.setSize(stageWidth, stageHeight);
    container.appendChild(renderer.domElement);

    var grid = {x: 0, z: 0};
    var position = {x: 0, y: 0, z: 0};
    init();

    function init() {
        cubes = [];
        stageWidth = $(window).width();
        stageHeight = $(window).height();
        camera = new THREE.PerspectiveCamera(55, stageWidth / stageHeight, 1, 20000);
        renderer.setSize(stageWidth, stageHeight-7);
        for (var x = 0; x < xRows; x++) {
            cubes[x] = [];
            for (var z = 0; z < zRows; z++) {
                var cubeHeight = 100 + Math.random() * 700;
                cubeHeight = 10 + (Math.sin(x / xRows * Math.PI) + Math.sin(z / zRows * Math.PI)) * 200 + Math.random() * 1000;
                var color = 0x0275d8;
                var _cubeSize = cubeSize;
                var geometry = new THREE.BoxGeometry(_cubeSize, cubeHeight, _cubeSize);
                
                if (cubeHeight > 1320)
                {
                    color = 0xff0000;
                    _cubeSize = cubeSize+100;                                        
                }
                var material = new THREE.MeshPhongMaterial({
                    ambient: color,
                    color: color,
                    specular: color,
                    shininess: 10,
                    shading: THREE.SmoothShading,
                });
                var cube = new THREE.Mesh(geometry, material);
                cube.position.x = halfXRows + x * cubeRow;
                cube.position.y = cubeHeight / 2;
                cube.position.z = (cubeRow * -zRows / 2) + z * cubeRow;

                cube.height = cubeHeight;
                group.add(cube);

                cubes[x][z] = cube;

            }
        }
    }

    function checkRow() {

        var xIndex = (position.x / cubeRow);
        var xLoops = Math.floor(xIndex / xRows);

        var zIndex = (position.z / cubeRow);
        var zLoops = Math.floor(zIndex / zRows);

        for (var x = 0; x < xRows; x++) {
            for (var z = 0; z < zRows; z++) {

                var dx, dz = 0;
                if (x >= xIndex - xLoops * xRows) {
                    dx = xRows * (1 - xLoops);
                } else {
                    dx = xRows * (0 - xLoops);
                }
                if (z >= zIndex - zLoops * zRows) {
                    dz = zRows * (1 - zLoops);
                } else {
                    dz = zRows * (0 - zLoops);
                }


                cubes[x][z].position.x = (x - dx) * cubeRow - halfXRows;
                cubes[x][z].position.z = (z - dz) * cubeRow - halfZRows;

                var scale = (cubes[x][z].position.z + group.position.z) / 1500;
                if (scale < 1)
                    scale = 1;
                scale = Math.pow(scale, 1.2);

                cubes[x][z].scale.y = scale;

                cubes[x][z].position.y = (cubes[x][z].height * scale) / 2;

            }
        }

    }
    var camPos = new THREE.Vector3(0, 0, 0);
    var mouse = {x: 0, y: 0};
    var isRunning = true;
    function render(t) {
        if (isRunning)
            requestAnimationFrame(render);

        position.x += (Math.sin(t * 0.001)) * 3;
        position.z += (Math.cos(t * 0.0008) + 5) * 3;
        group.position.x = -position.x;
        group.position.z = -position.z;


        checkRow();

        camera.position.x = Math.sin(t * 0.0003) * 1000;
        camera.position.z = -4000;
        camera.position.y = (Math.cos(Math.sin(t * 0.0009))+2) * 2000;                     
        camera.lookAt(camPos);

        renderer.render(scene, camera);

    }
    render(0);

    window.addEventListener("mousedown", function () {
        isRunning = !isRunning;
        if (isRunning)
        {
            render(0);
        }
    });

    $(document).ready(function ()
    {
        $('body').on("focus", "input", function (e) {
            e.stopPropagation();
            e.preventDefault();
            isRunning = false;
        });
    });
    window.addEventListener("mousemove", function (event) {
        mouse = event;
    });
    window.addEventListener("resize", function (event) {
        init();
        render(0);
    });
</script>    