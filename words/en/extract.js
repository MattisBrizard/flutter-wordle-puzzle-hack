const fs = require('fs');
const words = fs.readFileSync('words/fr/mots.txt').toString().split('\n');
const fiveLetterWords = JSON.parse(fs.readFileSync('words/en/5-letter-words.json').toString()).map((e) => e.word);
const fourLetterWords = JSON.parse(fs.readFileSync('words/en/4-letter-words.json').toString()).map((e) => e.word);


fs.writeFileSync(
  'lib/src/words/en.dart',
  `
    const enFourLettersWords = [${fourLetterWords.map((e) => `'${e}'`)},];
    const enFiveLettersWords = [${fiveLetterWords.map((e) => `'${e}'`)},];

  `
);
