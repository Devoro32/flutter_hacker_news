void main() {
  PowerGrid grid = PowerGrid();
  NuclearPlant nuclear = NuclearPlant();
  SolarPlant solar = SolarPlant();

  grid.addPlant(nuclear);
  grid.addPlant(solar);
}

//method and instances that ALL powerplants should have

//indicates that we are validating all the requirements for powerplants
class PowerGrid {
  // List<NuclearPlant> connectedPlants = []; rather than a specific type, now we are using PowerPlant
  List<PowerPlant> connectedPlants = [];

  //addPlant(NuclearPlant plant)- replacing NuclearPlant with a generic plant
  addPlant(PowerPlant plant) {
    plant.turnOn('duration 5 hours');
    connectedPlants.add(plant);
  }
}

abstract class PowerPlant {
  late int costOfEnergy;
  bool turnOn(String duration);
  //if you have a turnOn method it indicates that you are powerplants
}

class NuclearPlant implements PowerPlant {
  @override
  late int costOfEnergy;

  @override
  bool turnOn(String timeToStayOn) {
    print('I am a plan turning on');
    return true;
  }
}

class SolarPlant implements PowerPlant {
  @override
  late int costOfEnergy;

  @override
  bool turnOn(String howLongOn) {
    print('Turn on solarplant');
    return false;
  }
}
