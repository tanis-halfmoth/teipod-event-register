xquery version "3.1";

module namespace revent="http://teipublisher.com/api/registers/event";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";
import module namespace tpu="http://www.tei-c.org/tei-publisher/util" at "util.xql";
import module namespace vapi="http://teipublisher.com/api/view" at "lib/api/view.xql";
import module namespace page="http://teipublisher.com/ns/templates/page" at "templates/page.xqm";


declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function revent:sort($events as array(*)*, $dir as xs:string) {
    let $sorted :=
        sort($events, (), function($entry) {
            $entry?1
        })
    return
        if ($dir = "asc") then
            $sorted
        else
            reverse($sorted)
};

declare function revent:events-all($request as map(*)) {
    let $events := collection($config:register-root)/id($config:register-map?event?id)//tei:event
    return array {
        for $event in $events
        return map {
            "id": $event/@xml:id/string(),
            "desc": $event/tei:desc/string(),
            "when": $event/@when/string()
        }
    }
};

declare function revent:events-timeline($request as map(*)) {
    let $events := collection($config:register-root)/id($config:register-map?event?id)//tei:event
    let $datedEvents := filter($events,function($event) {
        $event/@when
        })
    let $formatted := map:merge((
        for $event in $datedEvents
        return map:entry(revent:normalize-date($event/@when/string()),
            map {
                "count":1,
                "info": array {
                    <span>{$event/tei:note}:{$event/tei:desc/string()}</span>
                }
            }
        )
    ))
    return $formatted
};

declare function revent:normalize-date($date as xs:string) {
    if (matches($date, "^\d{4}-\d{2}$")) then
        $date || "-01"
    else if (matches($date, "^\d{4}$")) then
        $date || "-01-01"
    else
        $date
};

declare function revent:events-categories($request as map(*)){
    let $search := normalize-space($request?parameters?search)
    let $sortDir := ($request?parameters?dir, 'asc')[1]
    let $odd := head(($request?parameters?odd, $config:default-odd))
    let $events :=
            if ($search and $search != '') then
                collection($config:register-root)/id($config:register-map?event?id)//tei:event[ft:query(., 'name:(' || $search || '*)')]
            else
                collection($config:register-root)/id($config:register-map?event?id)//tei:event
    let $byKey := for-each($events, function($event as element()) {
        let $label := $event/@when/string()
        return
            [lower-case($label), $label, $event]
    })
    let $sorted := revent:sort($byKey, $sortDir)
   
    return
        map {
            "items": revent:output-event-all($sorted, $odd),
            "categories": $byKey[1]
        }
};

declare function revent:output-event-all($list as array(*)*, $odd as xs:string) {
    array {
        for $event in $list
        let $note := 
            $pm-config:web-transform($event?3, map { "mode": "register-overview", "show-notes": true() }, $odd)
        return
            <div class="split-list-item">
            { $note }
            </div>
    }
};


