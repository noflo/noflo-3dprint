
3d-printing workflow prototype
---------------------

        noflo-cad (STL) -> noflo-print3d/slice -> $slicer (GCODE) -> noflo-print3d/print -> $printer (3DMODEL)
        other 3d tools  ->   " - "             ->
                                            other toolpath generators ->      " - "    ->
                                        other printer/job controllers ->      " - "

cura-server:
Stand-alone service for slicing
HTTP REST API, maybe WebSocket
AGPL license
Python + Twisted/gevent/etc. + Cura/CuraEngine
Minimal API:
- Upload STL file
- Slice with a given config
- Get progress on the process
- Get generated gcode
Long-term API:
- Get polygons for 3d-preview

noflo-print3d:
MIT licensed
Browser+node.js support
Generic components, take service object as parameter
Initial service backends for cura-server + octoprint
Maybe also a Shapeways backend

GetService/Backend -> {"service": "cura", "url": "http://FOO", "bar": "baz" }
ConnectService -> {}
CreateSliceJob -> {}
CreatePrintJob -> {}
GetJobStatus -> {"progress": 1.0 }
AbortJob

[noflo-cad](http://github.com/jonnor/noflo-cad)
