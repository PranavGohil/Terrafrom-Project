import unittest
from anagram import is_anagram


class TestAnagram(unittest.TestCase):

    def test_strings(self):
        result = is_anagram("", "")
        print('is_anagram("", "") =', result)
        self.assertTrue(result)

    def test_character(self):
        result = is_anagram("A", "A")
        print('is_anagram("A", "A") =', result)
        self.assertTrue(result)

    def test_different_characters(self):
        result = is_anagram("A", "B")
        print('is_anagram("A", "B") =', result)
        self.assertFalse(result)

    def test_anagram(self):
        result = is_anagram("ab", "ba")
        print('is_anagram("ab", "ba") =', result)
        self.assertTrue(result)

    def test_case_insensitive(self):
        result = is_anagram("AB", "ab")
        print('is_anagram("AB", "ab") =', result)
        self.assertTrue(result)

if __name__ == "__main__":
    unittest.main()
