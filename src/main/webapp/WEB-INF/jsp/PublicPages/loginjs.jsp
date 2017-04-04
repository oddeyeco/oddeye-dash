<%-- 
    Document   : loginjs
    Created on : Apr 4, 2017, 4:31:01 PM
    Author     : vahan
--%>
<script src='https://cdnjs.cloudflare.com/ajax/libs/three.js/r68/three.min.js'></script>
<script>
    var stageWidth = $(window).width();
    var stageHeight = $(window).height();
    var xRows = 40;
    var zRows = 25;
    var cubeSize = 450;
    var cubeGap = 150;
    var cubeRow = cubeSize + cubeGap;

    var container = document.createElement('div');
    document.body.appendChild(container);

    var camera = new THREE.PerspectiveCamera(55, stageWidth / stageHeight, 1, 20000);
    camera.position.y = 5000;
    camera.lookAt(new THREE.Vector3(0, 0, 0));

    var scene = new THREE.Scene();
    scene.fog = new THREE.Fog(0x000000, 5000, 10000);

    var pointLight = new THREE.PointLight(0x0275d8);
    pointLight.position.x = 0;
    pointLight.position.y = 1800;
    pointLight.position.z = -1800;
    scene.add(pointLight);

    /*var pointLight =  new THREE.PointLight(0xc0c0f0);
     pointLight.position.x = 0;
     pointLight.position.y = 800;
     pointLight.position.z = 1000;
     scene.add(pointLight);*/

    group = new THREE.Object3D();
    scene.add(group);

    var cubes = [];

    var halfXRows = (cubeRow * -xRows / 2);
    var halfZRows = (cubeRow * -zRows / 2);

    for (var x = 0; x < xRows; x++) {
        cubes[x] = []
        for (var z = 0; z < zRows; z++) {
            var cubeHeight = 100 + Math.random() * 700;
            cubeHeight = 10 + (Math.sin(x / xRows * Math.PI) + Math.sin(z / zRows * Math.PI)) * 200 + Math.random() * 150;

            var geometry = new THREE.BoxGeometry(cubeSize, cubeHeight, cubeSize);

            var colours = [
                0xffffff, 0xffffff, 0xffffff, 0xffffff
            ];

            var material = new THREE.MeshPhongMaterial({
                ambient: 0xffffff,
                color: 0xffffff,
                specular: 0xffffff,
                shininess: 10, //~~(Math.random() * 200),
                shading: THREE.SmoothShading
            })

            var cube = new THREE.Mesh(geometry, material);
            cube.position.x = halfXRows + x * cubeRow;
            cube.position.y = cubeHeight / 2;
            cube.position.z = (cubeRow * -zRows / 2) + z * cubeRow;

            cube.height = cubeHeight;
            group.add(cube);

            cubes[x][z] = cube;

        }
    }



    var renderer = new THREE.WebGLRenderer();
    renderer.setSize(stageWidth, stageHeight);
    container.appendChild(renderer.domElement);

    var out = document.createElement("div")
    container.appendChild(out);

    var grid = {x: 0, z: 0};
    var position = {x: 0, y: 0, z: 0};

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
                    dx = xRows * (0 - xLoops)
                }
                if (z >= zIndex - zLoops * zRows) {
                    dz = zRows * (1 - zLoops);
                } else {
                    dz = zRows * (0 - zLoops)
                }


                cubes[x][z].position.x = (x - dx) * cubeRow - halfXRows;
                cubes[x][z].position.z = (z - dz) * cubeRow - halfZRows

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
    var mouse = {x: 0, y: 0}
    var isRunning = true;
    function render(t) {
        if (isRunning)
            requestAnimationFrame(render);

        position.x += (Math.sin(t * 0.001)) * 5;
        position.z += (Math.cos(t * 0.0008) + 5) * 10;
        group.position.x = -position.x;
        group.position.z = -position.z;


        checkRow();

        camera.position.x = Math.sin(t * 0.0003) * 1000;// + mouse.y;
        camera.position.z = -4000;
        camera.position.y = (Math.cos(t * 0.0004) + 1.3) * 3000;
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
    })

    $(document).ready(function ()
    {
        $('body').on("focus", "input", function (e) {
            e.stopPropagation();
            e.preventDefault();
            isRunning = false;
        })
    })
    window.addEventListener("mousemove", function (event) {
        mouse = event;
    })
</script>    