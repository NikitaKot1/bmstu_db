from russian_names import RussianNames
import pycountry
import datetime
import csv
import random


params = {
    "number_beer": 1000,
    "number_of_buyings": 0,
    "number_manufacturer": 200,
    "number_of_factories": 1000,
    "number_of_restaurants": 2000,
    "number_of_consumers": 1000,
    "number_of_distributors": 100
} 

part3 = ['Maisel', 'Franziskaner', 'Erdinger', 'Paulaner', 'Aventinus', 'Pikantus', 'Ur-Weisse', 'Dunkel', 'Pfarrbräu', 'Ottos', 'Ottos', 'Roggen', 'München', 'Spaten', 'Pschorr', 'Augustinerbräu', 'Reissdorf', 'Mühlen', 'Gaffel', 'Früh', 'Maibock', 'Bock', 'Maibock', 'Ayilinger', 'Oktoberfest', 'Märzen', 'Bitburger', 'Radeberger', 'Becks', 'Krombacher', 'Flensburger', 'Bier', 'Dortmunder', 'Goslarer', 'Köllner', 'Altenauer', 'Ritterguts', 'Frankenheim', 'Oettingen', 'Diebels', 'Schumacher', 'Salvator', 'Optimator', 'Urbock', 'Dunkel', 'Korbinian', 'Weizen-Eisbock', 'Dark', 'Dunkel', 'Warsteiner', 'Köstritzer', 'Mönchshof', 'Kellerbier', 'Lager', 'Zoigl', 'Zoiglbauer', 'Bräu', 'Rauchbier', 'Spezial', 'Göller', 'Steam', 'Dampfbier', 'Scurry', 'Drop']
part2 = ['Unser', 'Erdinger', 'Ayinger', 'Hefe-Weisse', 'Paulaner', 'Hofbräu', 'Hacker', 'Huberts', 'Pschorr Oktoberfest', 'Jahrhundert', 'Doppelbock', 'Aventinus', '1516', 'Mitterteich', 'Gänstaller', 'Schlenkerla Rauchbier', 'Brauerei', 'Brewing', 'Dampfbierbrauerei', 'Brothers']
part1 = ['Franziskaner', 'Hacker-Pschorr', 'Hacker', 'Ayinger', 'Andechser', 'Weihenstephaner', 'Schneider', 'Hermannator Ice', 'Alt-Bayerisch', 'Spaten', 'Kloster', 'Weihenstephaner', 'Buttenheimer', 'Alt-Bayerisch', 'House', 'Zoigl', 'Mönchshof']
mark = []
manuf = []

def generate_beer():
    header = ['mark', 'alko', 'volume', 'price']
    with open('./tables/beer.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for i in range(params['number_beer']):
            marki = ''
            while (True):
                marki = ''
                ic1 = random.randint(0, 1)
                ic2 = random.randint(0, 1)
                if (ic1 == 1):
                    marki += random.choice(part1) + ' '
                if (ic2 == 1):
                    marki += random.choice(part2) + ' '
                marki = marki + random.choice(part3)
                if (marki not in mark):
                    break
            mark.append(marki)
            alko = random.randint(1, 100) / 10
            volume = random.randint(33, 50) / 100
            price = random.randint(29, 285)
            data = [marki, alko, volume, price]
            writer.writerow(data)
    print('beer was generated')

def generate_manufac():
    header = ['id', 'annual_turnover', 'net_profit', 'year_of_foundatrion']
    with open('./tables/manufacturers.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for i in range(params['number_manufacturer']):
            id = i
            annual = random.randint(100, 10000) / 100
            net_prof = annual * random.randint(20, 300) / 100
            year = random.randint(1400, 2012)

            marki = []
            col = random.randint(1, 4)
            for j in range(col):
                k = random.randint(0, len(mark)-1)
                if k not in marki:
                    marki.append(k)
            marks = ''
            for j in marki:
                marks += mark[j] + ','
            manuf.append(marks)

            data = [id, annual, net_prof, year]
            writer.writerow(data)
    print('manufacturers was generated')

def generate_factories():
    header2 = ['factory', 'beer']
    with open('./tables/beer_factories.csv', 'w', encoding='UTF8') as g:
        writer2 = csv.writer(g)
        writer2.writerow(header2)
        header = ['id', 'volume', 'country', 'master']
        with open('./tables/factories.csv', 'w', encoding='UTF8') as f:
            writer = csv.writer(f)
            writer.writerow(header)

            countries = {}
            for country in pycountry.countries:
                countries[country.name] = country.name
            co = []
            for c in countries:
                co.append(c)

            for i in range(params['number_of_factories']):
                id = i 
                country = random.choice(co)
                volume = random.randint(10, 1000) / 10
                manufac = random.randint(0, params['number_manufacturer'] - 1)

                marks = manuf[manufac]
                marki = marks.split(',')
                markii = ''
                j = random.randint(1, len(marki))
                for k in range(j):
                    data2 = [id, marki[k]]
                    writer2.writerow(data2)

                data = [id, volume, country, manufac]
                writer.writerow(data)
    print('factories was generated')

def generate_restoran():
    header = ['id', 'master', 'valume', 'suppliers']
    with open('./tables/restaurants.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for i in range(params['number_of_restaurants']):
            id = i
            master = RussianNames().get_person()
            value = random.randint(1000, 250000)
            supl = random.randint(0, params['number_manufacturer'] - 1)
            data = [id, master, value, supl]
            writer.writerow(data)
    print('restaurants was generated')

def generate_consumers():
    header = ['id', 'name', 'gender', 'lovely_beer', 'date_of_birth']
    start = datetime.datetime.strptime("01-01-1922", "%d-%m-%Y")
    end = datetime.datetime.strptime("01-01-2004", "%d-%m-%Y")
    date_generated = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]
    with open('./tables/consumers.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for i in range(params['number_of_consumers']):
            id = i
            name = RussianNames().get_person()
            gender = random.randint(0, 1)
            if gender:
                gender = 'M'
            else:
                gender = "F"
            birth = random.choice(date_generated)

            marki = random.choice(mark)

            data = [id, name, gender, marki, birth]
            writer.writerow(data)
    print('consumers was generated')

def generate_buyings():
    header = ['id', 'consumer', 'mark', 'price', 'date']
    with open('./tables/buyings.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
    print('buyings was generated')

def generate_distributors():
    header = ['id', 'marks', 'manufacturers', 'markup']
    with open('./tables/distributors.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        for i in range(params['number_of_distributors']):
            id = i
            
            manufaci = random.randint(0, params['number_manufacturer'] - 1)
            marks = manuf[manufaci]
            marki = marks.split(',')
            markii = ''
            j = random.randint(1, len(marki))
            for k in range(j):
                markii += marki[k] + ','
            
            markup = random.randint(1, 100)

            data = [id, markii, manufaci, markup]
            writer.writerow(data)

    print('distributors was generated')

def generate_beer_manufac():
    header = ['manufacturer', 'beer']
    with open('./tables/beer_manufacturers.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header) 
        for i in range(params["number_manufacturer"]):
            marki = []
            col = random.randint(1, 5)
            for j in range(col):
                k = random.randint(0, len(mark)-1)
                if k not in marki:
                    marki.append(k)
                    data = [i, mark[k]]
                    writer.writerow(data)
            

def main():
    generate_beer()
    generate_manufac()
    generate_factories()
    generate_consumers()
    generate_restoran()
    generate_buyings()
    generate_distributors()
    generate_beer_manufac()


if __name__ == "__main__":
    main()