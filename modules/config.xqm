xquery version "3.1";

(:~
 : A set of helper functions to access the application context from
 : within a module.
 :)
module namespace config="http://www.tei-c.org/tei-simple/config";

import module namespace gen="https://e-editiones.org/tei-publisher/generator/config" at "generated-config.xql";
import module namespace http="http://expath.org/ns/http-client" at "java:org.exist.xquery.modules.httpclient.HTTPClientModule";
import module namespace nav="http://www.tei-c.org/tei-simple/navigation" at "navigation.xql";
import module namespace tpu="http://www.tei-c.org/tei-publisher/util" at "lib/util.xql";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace errors = "http://e-editiones.org/roaster/errors";

declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace jmx="http://exist-db.org/jmx";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $config:register-map := map {
    "person": map {
        "id": "pb-persons",
        "default": "person-default",
        "prefix": "person-"
    },
    "place": map {
        "id": "pb-places",
        "default": "place-default",
        "prefix": "place-"
    },
    "organization": map {
        "id": "pb-organizations",
        "default": "organization-default",
        "prefix": "org-"
    },
    "event": map {
        "id": "pb-events",
        "default": "event-default",
        "prefix": "event-"}
};
