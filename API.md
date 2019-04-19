# kiosk API

Extrahiert aus [kiosk_v4](https://github.com/shackspace/kiosk_v4/).

## Portal Query

http://portal.shack:8088/status

```json
{
	"status":"open",
	"keyholder":"map",
	"timestamp":1555628462290
}
```

## Müll

http://openhab.shack/muellshack/gelber_sack
http://openhab.shack/muellshack/papiermuell
http://openhab.shack/muellshack/restmuell

```json
{
	"date":"2019-05-14",
	"muelltype":"restmuell",
	"restmuell":"2019-05-14",
	"main_action_done":false,
	"mail_sended":false
}
```

## Issues

https://api.github.com/repos/shackspace/spaceIssues/issues?state=open

(Kein Sample, da too much code)

## Stromverbrauch

http://glados.shack/siid/apps/powermeter.py?n=10

n ist vergangene Zeit in Sekunden

```json
{
	"Total": [2609, 2626, 2619, 2628, 2608, 2617, 2642, 2673, 2638, 2629],
	"L1.Power": [855, 852, 849, 863, 840, 854, 882, 889, 882, 850],
	"L2.Power": [825, 830, 835, 828, 829, 829, 826, 831, 829, 834],
	"L3.Power": [929, 944, 935, 937, 939, 934, 934, 953, 927, 945],
	"Minutes ago": [-0.3, -0.26666666666666666, -0.23333333333333334, -0.2, -0.16666666666666666, -0.13333333333333333, -0.1, -0.06666666666666667, -0.03333333333333333, 0.0]}
```

## Bahnfahrten

https://efa-api.asw.io/api/v1/station/5000082/departures/

```json
[
    {
        "direction": "Rathaus",
        "stopName": "Im Degen",
        "stationCoordinates": "48.77793,9.23355",
        "delay": 9,
        "number": "U4",
        "departureTime": {
            "month": "4",
            "year": "2019",
            "minute": "0",
            "hour": "1",
            "weekday": "6",
            "day": "19"
        }
    }
]
```

## Licht-API

### Query
http://openhab.shack/lounge/1
…
http://openhab.shack/lounge/8

```json
{
	"id":1,
	"state":"off"
}
```

### Control

http://openhab.shack/lounge/*n*

HTTP-Put

```json
{
	"state", "on"
}
```


## Gobbelz

http://gobbelz.shack/say/ (POST)

```js
function gobbelz(text)
{
	var req = new XMLHttpRequest();
	req.open("POST", "http://gobbelz.shack/say/", true);
	req.setRequestHeader("Content-type","application/json");
	req.send(JSON.stringify({"text": text}));
}
```

