# Particle Simulation
[Falling sand](https://en.wikipedia.org/wiki/Falling-sand_game) game using [OCSFW](https://github.com/psychopattt/OCSFW) (GLFW, OpenGL and Dear ImGui)
<br>
Demo video available [here](https://youtu.be/rCaVBj4KN5U)

## Features
- 31 particle types
  - Map up to 5 particles to mouse buttons
  - Particle behaviors [here](#particles)
- Draw settings
  - Toggle between draw mode and view mode (E)
  - Select draw radius (scroll wheel)
- Customizable post-processing
  - Background and outline colors
  - Brightness, saturation and contrast
- Particle info window
  - Customize position
  - Select displayed info: Type, phase, density and shade
- All features of [OCSFW](https://github.com/psychopattt/OCSFW?tab=readme-ov-file#features)

## Particles
Particle    | Phase  | Density | Behaviors
----------- | :----: | :-----: | ---------
Acid        | Liquid | 1020    | Dissolves most particles at varying rates, slowly vaporizes into smoke
Ammonia     | Gas    | 0.769   | Burns very slowly, fertilizes plants, ignites chlorine and dissolves foam
Brick       | Solid  | 2060    | Stacks up in columns, withstands lava
Cement      | Liquid | 1400    | Slowly hardens, melts into lava
Chlorine    | Gas    | 3.2     | Kills plants, is ignited by ammonia and iron, dissolves in water to make seawater, dissolves foam
Clear (Air) | Gas    | 1.292   | Basic background particle
Cloner      | Static | 2000    | Clones neighboring particles, inert and indestructible
Fire        | Static | 1.62    | Burns various particles, produces smoke, is quenched by water and seawater
Foam        | Liquid | 673.4   | Quickly expands into low density foam, is dissolved by chlorine, lava, methane and petrol, insulates hot wax
Grass       | Solid  | 1200    | Grows mostly horizontally, is killed by various particles, burns
Ice         | Static | 916.8   | Freezes water, is melted by fire, lava, salt and hot wax
Iron        | Static | 7874    | Is rusted by various particles, ignites chlorine
Kelp        | Solid  | 980     | Grows in water and seawater, is killed by various particles, converts to water on death
Lava        | Liquid | 1300    | Melts and burns various particles, slowly solidifies into rock
Mercury     | Liquid | 13546   | Extremely dense liquid
Methane     | Gas    | 0.717   | Burns violently, kills plants, dissolves foam
Petrol      | Liquid | 755     | Burns quickly, kills plants, dissolves foam
Random      | Static | 1000    | Converts to a random particle
Rock        | Solid  | 2600    | Stacks up in unstable piles, melts into lava
Rust        | Solid  | 5250    | Melts into lava
Salt        | Solid  | 2170    | Dissolves in water to make seawater, melts ice, melts into lava, kills plants, slowly rusts iron
Sand        | Solid  | 1602    | Withstands lava and acid
Sawdust     | Solid  | 1471    | Burns quickly
Seawater    | Liquid | 1023.6  | Vaporized into steam by fire and lava, quenches fire, solidifies lava, quickly rusts iron
Smoke       | Gas    | 0.81    | Slowly dissipates, slowly kills plants
Steam       | Gas    | 0.59    | Condensates into water, rusts iron
Vine        | Static | 342     | Grows on most particles, is killed by various particles, burns
Wall        | Static | 10000   | Inert and indestructible
Water       | Liquid | 999.84  | Dissolves salt and chlorine, vaporized into steam by fire and lava, quenches fire, solidifies lava, rusts iron
Wax         | Static | 900     | Melted by fire and lava, slowly cools down
Wood        | Static | 685     | Burns slowly

## Requirements
- An OpenGL 4.6 capable GPU

## How to use
Windows
1. Download the [latest release](https://github.com/psychopattt/Particle-Simulation/releases/latest) (Particle-Simulation.exe)
2. Run the executable

## Credits
- [OCSFW](https://github.com/psychopattt/OCSFW?tab=readme-ov-file#credits)
- [PCG4D](https://github.com/markjarzynski/pcg3d)
