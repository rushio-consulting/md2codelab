function loadJSON(callback) {

    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', 'md_search.json', true);
    xobj.onreadystatechange = function () {
        if (xobj.readyState == 4 && xobj.status == "200") {
            // .open will NOT return a value but simply returns undefined in async mode so use a callback
            callback(xobj.responseText);
        }
    }
    xobj.send(null);
}

var idx;

// Call to function with anonymous callback
loadJSON(function (response) {
    // Do Something with the response e.g.
    documents = JSON.parse(response);

    // Assuming json data is wrapped in square brackets as Drew suggests

    idx = lunr(function () {
        this.ref('path')
        this.field('codelab')
        this.field('title')
        this.field('content')

        documents.forEach(function (doc) {
            this.add(doc)
        }, this)

    });
    console.log(idx);

});


var search = function (value) {
    return idx.search(value);
}
