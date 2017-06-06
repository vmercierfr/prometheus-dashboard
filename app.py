import json
import logging
import os
import redis

from flask import Flask, request, render_template

app = Flask(__name__)
app.config.from_object('config')

# Set logger
log_level = logging.DEBUG if app.config['DEBUG'] else logging.WARNING
logging.basicConfig(level=logging.DEBUG, format='[%(levelname)s] %(message)s')

# Setup redis connection
r = redis.StrictRedis(host='redis', port=6379, db=2)

def get_alerts():
    """
    Return current alerts and stats
    """
    # Initialization
    alerts = []
    hosts = []
    stats = {
        'alerts': 0,
        'hosts': 0,
    }
    # Loop on each alert
    for key in r.scan_iter():
        alert = json.loads(r.get(key).decode('utf8'))
        if not alert['labels']['instance'] in hosts:
            hosts.append(alert['labels']['instance'])
            stats['hosts'] += 1
        alerts += [alert]
    stats['alerts'] = len(alerts)
    return alerts, stats

@app.route('/', methods=['GET'])
def home():
    alerts, stats = get_alerts()
    return render_template('home.html', alerts=alerts, stats=stats)

@app.route('/report', methods=['POST'])
def report():
    data = json.loads(request.data.decode('utf8'))
    alerts = data['alerts']
    for alert in alerts:
        alert_id = '%s_%s' % (alert['labels']['instance'], alert['labels']['alertname'])
        if alert['status'] == 'resolved':
            r.delete(alert_id)
        else:
            r.set(alert_id, json.dumps(alert))
            r.expire(alert_id, app.config['ALERT_TTL'])
    return 'Ok'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=app.config['PORT'])