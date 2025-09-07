const AWS = require("aws-sdk");
const s3 = new AWS.S3();

function isAnagram(word1, word2) {
  return word1.split("").sort().join("") === word2.split("").sort().join("");
}

exports.handler = async (event) => {
  try {
    const bucket = event.Records[0].s3.bucket.name;
    const key = event.Records[0].s3.object.key;

    if (key !== "anagram.csv") {
      console.log("Not the anagram file");
      return;
    }

    const params = { Bucket: bucket, Key: key };
    const data = await s3.getObject(params).promise();
    const fileContent = data.Body.toString("utf-8");

    const words = fileContent.split(/\r?\n/).filter(Boolean);

    const results = [];
    for (let i = 0; i < words.length; i++) {
      for (let j = i + 1; j < words.length; j++) {
        if (isAnagram(words[i], words[j])) {
          results.push([words[i], words[j]]);
        }
      }
    }

    console.log("Found anagrams:", results);

    return {
      statusCode: 200,
      body: JSON.stringify({ results }),
    };
  } catch (err) {
    console.error("Error:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
