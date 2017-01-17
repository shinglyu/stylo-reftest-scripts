import json
import os
import re
import urllib2
import time

def sorted_alphanumeric( l ):
    """ Sorts the given iterable in the way that is expected.

    Required arguments:
    l -- The iterable to be sorted.

    """
    convert = lambda text: int(text) if text.isdigit() else text
    alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
    return sorted(l, key = alphanum_key)


def main():
    # Parameterize the filename
    filename = 'task-graph.json'
    with open(filename, 'rb') as f:
        taskgraph = json.loads(f.read())

    label_to_id = {}
    for (key, val) in taskgraph.iteritems():
        # if val['label'].startswith('desktop-test-linux64-stylo/opt-reftest-stylo-') and not "e10s" in val['label']:
        if val['label'].startswith('test-linux64-stylo/opt-reftest-stylo-') and not "e10s" in val['label']:
            label_to_id[val['label']] = key
    if len(label_to_id) == 0:
        print("Can't find anything in the task graph")

    dirname = 'reftest-log-' + time.strftime("%Y-%m-%d-%H_%M_%S")
    if not os.path.exists(dirname):
        os.makedirs(dirname)

    for label in sorted_alphanumeric(label_to_id.keys()):
        #print 'Downloading ' + label
        filename_safe_label = label.replace('/', '_')
        url = 'https://public-artifacts.taskcluster.net/{0}/0/public/test_info//reftest-stylo_errorsummary.log'.format(label_to_id[label])
        filename = './{path}/{label}.json'.format(path=dirname, label=filename_safe_label)

        time.sleep(1)
        response = urllib2.urlopen(url)
        payload = response.read()

        with open(filename, 'wb') as f:
            f.write(payload)
        print "Saving " + url + " to " + filename
    # https://public-artifacts.taskcluster.net/bA-y-xj4RjOOlSckti6tgA/0/public/test_info//reftest-stylo_errorsummary.log
    # https://public-artifacts.taskcluster.net/NjA3h4f7TpqEKBg9JJ3_Ew/0/public/test_info//reftest-stylo_errorsummary.log

if __name__ == "__main__":
    main()
