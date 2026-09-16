const fs = require('fs');
const svgpath = require('svgpath');
const { JSDOM } = require('jsdom');

const svgStr = fs.readFileSync('Plan/vecteezy_set-of-arabic-alphabet-vector_8787321.svg', 'utf8');
const dom = new JSDOM(svgStr);
const paths = dom.window.document.querySelectorAll('path');

// Read the old Dart file to map letter to path index? No, we don't know the mapping.
// Wait! We can just use flutter_svg!
