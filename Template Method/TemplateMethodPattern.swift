// Solution @ Sergey Leschev, Belarusian State University

protocol Garden {
    func prepareSoil()
    func plantSeeds()
    func waterPlants()
    func prepareGarden()
}

extension Garden {

    func prepareGarden() {
        prepareSoil()
        plantSeeds()
        waterPlants()
    }
}

final class RoseGarden: Garden {

    func prepare() {
        prepareGarden()
    }

    func prepareSoil() {
        print ("prepare soil for rose garden")
    }

    func plantSeeds() {
        print ("plant seeds for rose garden")
    }

    func waterPlants() {
       print ("water the rose garden")
    }
}