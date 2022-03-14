const fs = require('fs');
const words = fs.readFileSync('words/fr/mots.txt').toString().split('\n');
const fiveLetterWords = words.filter((word) => word.length === 5);
const fourLetterWords = words.filter((word) => word.length === 4);
fs.writeFileSync(
  'words/fr/words.dart',
  `
    const frFourLettersWords = [${fourLetterWords.map((e) => `'${e}'`)},];
    const frFiveLettersWords = [${fiveLetterWords.map((e) => `'${e}'`)},];

  `
);
