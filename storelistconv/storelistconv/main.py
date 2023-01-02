import sys
import codecs
import xmltodict


def eprint(*args):
    print(*args, file=sys.stderr)


def main():
    try:
        infile = open(sys.argv[1], "r")
    except FileNotFoundError:
        eprint('ERROR: Specified input file "{}" not found.'.format(
            sys.argv[1]))
        sys.exit(1)

    xml_content = infile.read()
    infile.close()

    store_dict = xmltodict.parse(xml_content)

    droppoint = {'ArrayOfDropPointData':
                 {'@xmlns:xsd': 'http://www.w3.org/2001/XMLSchema',
                  '@xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
                  'DropPointData': []}}

    droppoints = droppoint['ArrayOfDropPointData']['DropPointData']

    for i in store_dict['ArrayOfStoreDTO']['StoreDTO']:
        try:
            dp = {'OriginalId': i['StoreSapId'],
                  'Name1': i['StoreName'],
                  'Address1': i['Addresses']['Address']['AddressLine1'],
                  'Address2': i['Addresses']['Address']['AddressLine2'],
                  'City': i['Addresses']['Address']['City'],
                  'PostalCode': i['Addresses']['Address']['PostalCode'],
                  'MapRefX': i['Addresses']['Address']['Longitude'],
                  'MapRefY': i['Addresses']['Address']['Latitude'],
                  'Phone': i['Contacts']['Contact']['PhoneNumber'],
                  'Email': i['Contacts']['Contact']['EMailAddress'],
                  'Fax': i['Contacts']['Contact']['FaxNumber'],
                  'CountryCode': 'NO',
                  'OpeningHoursList': {'OpeningHours': []},
                  'District': '',
                  'County': '',
                  'Region': '',
                  'Province': '',
                  'State': '',
                  'Depot': '',
                  'RoutingCode': ''}
        except TypeError:
            eprint('Skipping {} ({})'.format(i['StoreName'], i['StoreSapId']))
        for j in i['OpeningHours']['OpeningHour']:
            openinghours = {'Day': j['Weekday'],
                            'Open': j['FromTime'][0:5],
                            'Close': j['ToTime'][0:5]}
            dp['OpeningHoursList']['OpeningHours'].append(openinghours)
        droppoints.append(dp)

    with codecs.open(sys.argv[2], 'w', 'utf-8') as outfile:
        outfile.write('\ufeff')  # Add Byte Order Mark
        xmlout = xmltodict.unparse(droppoint,
                                   pretty=True, indent='  ',
                                   short_empty_elements=True)
        outfile.write(xmlout)


if __name__ == "__main__":
    main()
