"""
Created in February, 2023 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[toolips](https://github.com/orgs/ChifiSource/teams/toolips)
This software is MIT-licensed.
### ToolipsSVG
This module brings an array of different Components, as well as making things
work more thoroughly with paths.
###### exports
Path interface
- `M!`
- `L!`
- `Z!`
- `Q!`
- `C!`
- `A!`

Position, shape, and size.
- `size(::Component{<:Any})`
- `set_size!`
- `get_position`
- `set_position!`
- `get_shape`
- `set_shape!`

Regular Components
- `text`
- `path`
- `image`
- `circle`
- `rect`
- `line`
- `ellipse`
- `polygon`
- `polyline`
- `use`
- `g`
- `svg`
- `div`
- `tmd`

SVG Shapes
- `star`
- `polyshape`
"""
module ToolipsSVG
import Base: size, string
using ToolipsServables

"""
```julia
M!(path::Component{:path}, points::Any ...) -> ::String
```
`M!` adds an `M` to the `d` data of a `path`. `M` is *move* -- this moves 
the `path` cursor to a set position.
---
```example
# create our path:
squarepath = path("new-square")
M!(squarepath, 50, 50)
L!(squarepath, 100, 50)
L!(squarepath, 100, 100)
L!(squarepath, 50, 100)
L!(squarepath, 50, 50)
Z!(squarepath)
# add to svg window:
window = svg("main", width = 500, height = 500)
push!(window, squarepath)
# -- display
display("text/html", window)
```
```example
cuteheart = path("heat")
M!(cuteheart, 12, "21.593c-5.63-5.539-11-10.297-11-14.402", 
"0-3.791 3.068-5.191 5.281-5.191 1.312", 0, "4.151.501", 
5.719, 4.457, "1.59-3.968", "4.464-4.447",
 "5.726-4.447", 2.54, 0, 5.274, 1.621, 5.274, 5.181, 0,
 "4.069-5.136 8.625-11", "14.402m5.726-20.583c-2.203", "0-4.446 1.042-5.726 3.238-1.285-2.206-3.522-3.248-5.719-3.248-3.183",
  "0-6.281", "2.187-6.281", 6.191, 0, 4.661, 5.571, 9.429, 12, 15.809, "6.43-6.38 12-11.148 12-15.809",
   "0-4.011-3.095-6.181-6.274-6.181")

window = svg("main", width = 500, height = 500)
push!(window, cuteheart)
display("text/html", window)
```
"""
M!(path::Component{:path}, a::Any ...) = path["d"] = path["d"] * "M$(join((string(el) for el in a), " "))"

"""
```julia
L!(path::Component{:path}, points::Any ...) -> ::String
```
`L!` adds an `L` to the `d` data of a `path`. `L` is *line-to*, which draws 
a line from the current path position to the new `xy` position.
---
```example
using ToolipsSVG
# create our path:
squarepath = path("new-square")
M!(squarepath, 50, 50)
L!(squarepath, 100, 50)
L!(squarepath, 100, 100)
L!(squarepath, 50, 100)
L!(squarepath, 50, 50)
Z!(squarepath)
# add to svg window:
window = svg("main", width = 500, height = 500)
push!(window, squarepath)
# -- display
display("text/html", window)
```
"""
L!(path::Component{:path}, a::Any ...) = path["d"] = path["d"] * "L$(join((string(el) for el in a), " "))"

"""
```julia
Z!(path::Component{:path}) -> ::String
```
`Z!` adds a `Z` to the `d` data of a `path`. `Z` is used to close a `path`.
---
```example
using ToolipsSVG
# create our path:
squarepath = path("new-square")
M!(squarepath, 50, 50)
L!(squarepath, 100, 50)
L!(squarepath, 100, 100)
L!(squarepath, 50, 100)
L!(squarepath, 50, 50)
Z!(squarepath)
# add to svg window:
window = svg("main", width = 500, height = 500)
push!(window, squarepath)
# -- display
display("text/html", window)
```
"""
Z!(path::Component{:path}) = path["d"] = path["d"] * "Z"

"""
```julia
Q!(path::Component{:path}, a::Any ...) -> ::String
```
`Q!` adds a `Q` to the `d` data of a `path`.  The `Q` option 
performs a quadratic bezier command.
---
```example
new_path = path("new-path")
M!(new_path, "100,250")
Q!(new_path, "250,100", "400,250")
Z!(new_path)
# -- display
display("text/html", window)
```
"""
Q!(path::Component{:path}, a::Any ...) = path[:d] = path[:d] * "Q$(join((string(el) for el in a), " "))"

"""
```julia
C!(path::Component{:path}, a::Any ...) -> ::String
```
`C!` adds a `C` to the `d` data of a `path`.  The `C` option 
performs a cubic bezier command.
"""
C!(path::Component{:path}, a::Any ...) = path[:d] = path[:d] * "C$(join((string(el) for el in a), " "))"

"""
```julia
A!(path::Component{:path}, a::Any ...) -> ::String
```
`A!` adds a `A` to the `d` data of a `path`.  The `A` option 
performs an eliptical arch.
"""
A!(path::Component{:path}, a::Any ...) = path[:d] = path[:d] * "A$(join((string(el) for el in a), " "))"

"""
```julia
size(comp::Component{<:Any}) -> ::Tuple{Int64, Int64}
```
Returns the x/y dimensions of any SVG `Component` with a `size` binding. 
Position and size for different SVGComponents is stored differently, so this 
    `Function` is used with multiple dispatch to get the size of any component.
`ToolipsSVG` provides bindings for`Component{:rect}`, `Component{:circle}`, `Component{:star}`, and `Component{:polyshape}`.
Size may also be set with dispatch using `set_size!`.
---
```example
using ToolipsSVG
circ = circle("sample", cx = 5, cy = 5, r = 6)
size(circ)
(6, 6)

rct = rect("samp-rect", x = 5, y = 5, width = 20, height = 10)
size(rct)
(20, 10)
```
- See also: `position`, `star`, `polyshape`, `Component`, `set_size!`, `set_position!`
"""
size(comp::Component{<:Any}) = (comp[:width], comp[:height])
size(comp::Component{:rect}) = (comp[:width], comp[:height])
size(comp::Component{:circle}) = (comp[:r], comp[:r])

"""
```julia
get_position(comp::Component{<:Any}) -> ::Tuple{Int64, Int64}
```
Similar to `size(comp::Component{<:Any})`, this `Function` is 
used to get the position of many different SVG component types 
in the same way. Also like size, position may also be set with 
`set_position!`.
---
```example
using ToolipsSVG
rct = rect("samp-rect", x = 5, y = 5, width = 20, height = 10)
get_position(rct)
(5, 5)
```
- See also: `size(<:ToolipsSVG.ToolipsServables.AbstractComponent)`, `set_size!`, `set_position!`
"""
get_position(comp::Component{<:Any}) = (comp[:x], comp[:y])
get_position(comp::Component{:circle}) = (comp[:cx], comp[:cy])

"""
```julia
set_size!(comp::Component{<:Any}, w::Number, h::Number) -> ::Number
```
`set_size` sets the size of the `Component` `comp`, can be used 
with multiple dispatch to create consistent size keying for multiple 
    SVG element types.
---
```example
using ToolipsSVG
circ = circle("sample", cx = 5, cy = 5, r = 6)
size(circ)
(6, 6)
set_size!(circ, 9, 10)
size(circ)
(9, 10)

newrect = rect("examplerect", x = 50, y = 70, width = 400, height = 200)
set_size!(newrect, size(circ) ...)

size(newrect)
(9, 10)
```
- See also: `size`, `star`, `polyshape`, `set_position!`, set_shape!
"""
set_size!(comp::Component{<:Any}, w::Number, h::Number) = comp.properties[:width], comp.properties[:height] = w, h
set_size!(comp::Component{:circle}, w::Number, h::Number) = begin
    comp.properties[:r] = w
end

"""
```julia
set_position!(comp::Component{<:Any}, x::Number, y::Number) -> ::Number
```
Sets the position of `comp` to `x` and `y`.
---
```example
newrect = rect("examplerect", x = 50, y = 70, width = 400, height = 200)
get_position(new_rect)
(50, 760)

set_position!(new_rect, (70, 90) ...)
get_position(new_rect)
(70, 90)
```
- See also: `get_position`, `get_shape`, `set_shape!`, `size(::Component{<:Any})`
"""
set_position!(comp::Component{<:Any}, x::Number, y::Number) = comp.properties[:x], comp.properties[:y] = x, y

set_position!(comp::Component{:circle}, x::Number, y::Number) = comp.properties[:cx], comp.properties[:cy] = x, y

const text = Component{:text}
const image = Component{:image}
const circle = Component{:circle}
const rect = Component{:rect}

function path(name::String, args::Pair{String, <:Any} ...; d::String = "", keyargs ...)
    Component{:path}(name, "d" => d, args ...; keyargs ...)
end

const line = Component{:line}
const ellipse = Component{:ellipse}
const polyline = Component{:polyline}
const polygon = Component{:polygon}
const use = Component{:use}
const g = Component{:g}

"""
### abstract type SVGShape{T <: Any}
The `SVGShape` is used as a parameteric type to represent shape. 
This is used to create functions where a shape might want to be 
provided in an argument. For instance, `set_shape!` uses the `SVGShape` 
to turn a `Component` into a different `Component`, of a different shape, 
with the same `size` and `position`
- See also: `get_shape`, `set_shape`
"""
abstract type SVGShape{T <: Any} end

"""
```julia
get_shape(comp::Component{<:Any}) -> ::SVGShape{<:Any}
---
Retrieves the `SVGShape` of `comp`, which is simply the component's 
type parameter. `SVGShape` is used to provide conversions with `set_shape!`.
```example
firstshape::Component{:rect} = rect("sample", x = 5, y = 5, )
second_shape::Component{:star} = star("secondsample", x = 20, y = 10)
shape::SVGShape{:star} = get_shape(second_shape)

set_shape!(firstshape, shape)
get_position(firstshape)
(5, 5)

println(get_shape(firstshape))
SVGShape{:star}
# or
set_shape!(firstshape, :rect)
```
- `set_shape!`, `SVGShape`, `get_shape`, `ToolipsSVG`, `size(::Component{<:Any})`
"""
get_shape(comp::Component{<:Any}) = SVGShape{typeof(comp).parameters[1]}

"""
```julia
set_shape!(comp::Component{<:Any}, into::Symbol; args ...)
---
`set_shape!` is used to turn a shape into another shape with the same 
size and position.

```example
firstshape::Component{:rect} = rect("sample", x = 5, y = 5, )
second_shape::Component{:star} = star("secondsample", x = 20, y = 10)
shape::SVGShape{:star} = get_shape(second_shape)

set_shape!(firstshape, shape)
get_position(firstshape)
(5, 5)

println(get_shape(firstshape))
SVGShape{:star}
# or
set_shape!(firstshape, :rect)
```
"""
set_shape!(comp::Component{<:Any}, into::Symbol; args ...) = set_shape!(comp, SVGShape{into}; args ...)

function set_shape!(shape::Component{<:Any}, into::Type{SVGShape{:star}}; outer_radius::Number = 5, inner_radius::Number = 3,
    points::Number = 5, args ...)
    s = get_position(shape)
    star(shape.name, x = s[1], y = s[2], outer_radius = outer_radius, inner_radius = inner_radius, points = points)::Component{:star}
end

function set_shape!(shape::Component{<:Any}, into::Type{SVGShape{:square}}; args ...)
    xy = get_position(shape)
    rad = size(comp)
    rect(randstring(4), x = xy[1], y = xy[2], width = rad[1], height = rad[1])::Component{:rect}
end

function set_shape!(comp::Component{<:Any}, into::Type{SVGShape{:polyshape}}; sides::Number = 3, angle::Number = 2 * pi / sides, args ...)
    s = get_position(comp)
    rad = size(comp)
    polyshape(comp.name, x = s[1], y = s[2], sides = sides, r = rad[1], angle = angle)::Component{:polyshape}
end

function set_shape!(shape::Component{<:Any}, into::Type{SVGShape{:rect}}; args ...)
    s = get_position(shape)
    dims = size(comp)
    rect(shape.name, x = s[1], y = s[2], width = dims[1], height = dims[2])::Component{:rect}
end

function set_shape!(shape::Component{<:Any}, into::Type{SVGShape{:circle}}; args ...)
    s = get_position(shape)
    r = size(shape)[1]
    circle(shape.name, cx = s[1], cy = s[2], r = r)::Component{:circle}
end

function star_points(x::Number, y::Number, points::Number, outer_radius::Number, inner_radius::Number, 
    angle::Number)
    step = pi / points
    join([begin
        r = e%2 == 0 ? inner_radius : outer_radius
        posx = x + r * cos(i)
        posy = y + r * sin(i)
        "$posx $posy"
    end for (e, i) in enumerate(range(0, step * (points * 2), step = step))], ",")::String
end

"""
```julia
star(name::String, p::Pair{String, <:Any} ...; x::Number = 0, y::Number = 0, points::Number = 5, 
outer_radius::Number = 100, inner_radius::Number = 200, angle::Number = pi / points, args ...) -> ::Component{:star}
```
Builds a special `SVG` `:star` `Component`. This is a `:polygon` tagged element 
that is specially typed in order to become a composable star. Similarly, `ToolipsSVG` also provides the 
`polyshape` `Component`.
---
```example
using ToolipsSVG
newshape::Component{:star} = star("mynewstar", x = 5, y = 6, points = 6)
```
"""
function star(name::String, p::Pair{String, <:Any} ...; x::Number = 0, y::Number = 0, points::Number = 5, 
    outer_radius::Number = 100, inner_radius::Number = 200, angle::Number = pi / points, args ...)
    spoints = star_points(x, y, points, outer_radius, inner_radius, angle)
    comp::Component{:star} = Component{:star}(name, "points" => "'$spoints'", p ...; tag = "polygon", args ...)
    push!(comp.properties, :x => x, :y => y, :r => outer_radius, :angle => angle, 
    :np => points, :ir => inner_radius)
    comp::Component{:star}
end

set_position!(comp::Component{:star}, x::Number, y::Number) = begin
    pnts, angle, outer_radius, ir = comp[:np], comp[:angle], comp[:r], comp[:ir]
    spoints = star_points(x, y, pnts, outer_radius, ir, angle)
    comp["points"] = "'$spoints'"
    nothing
end

function size(comp::Component{:star})
    (comp[:r], comp[:r])
end

function shape_points(x::Number, y::Number, r::Number, sides::Number, angle::Number)
    join([begin
        posx = x + r * sin(i * angle)
        posy = y + r * cos(i * angle)
        "$posx $posy"
    end for i in 1:sides], ",")::String
end

"""
```julia
polyshape(name::String, p::Pair{String, <:Any} ...; x::Number = 0, y::Number = 0,
sides::Number = 3, r::Number = 100, angle::Number = 2 * pi / sides, args ...) -> ::Component{:star}
```
Builds a `polyshape` component, which is an `SVGShape` compatible with SVG functions from 
`ToolipsSVG`.
---
```example
using ToolipsSVG
newshape::Component{:polyshape} = polyshape("mynewpoly", x = 5, y = 6, sides = 4)
```
"""
function polyshape(name::String, p::Pair{String, <:Any} ...; x::Number = 0, y::Number = 0, 
    sides::Number = 3, r::Number = 100, angle::Number = 2 * pi / sides, args ...)
    points = shape_points(x, y, r, sides, angle)
    comp::Component{:polyshape} = Component{:polyshape}(name, "points" => "'$points'", p ...; tag = "polygon", args ...)
    push!(comp.properties, :x => x, :y => y, :r => r, :sides => sides, :angle => angle)
    comp::Component{:polyshape}
end

function size(comp::Component{:polyshape})
    (comp[:r], comp[:r])
end

export circle, path, rect, star, svg, div, tmd, g, polyshape, line, path, image, text, polyline, polygon, use, ellipse
export set_position!, get_shape, set_size!, get_position, polyshape, Component, AbstractComponent, set_shape!, style!
export M!, L!, Z!, Q!
end # module
