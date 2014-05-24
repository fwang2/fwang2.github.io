## setup spell check

Well, this is actually tricky.

1. copy /usr/shared/dict/web2 to home directory, say ~/spell

2. rename it to en.dict

3. Texlipse Latex project properties, make sure language encoding is "en"

4. enable built in spell check in Eclipse

5. Preference/Texlipse, in the spell check section, we need to provide the
directory name for where the main dictionary is located. So in this case, it
is `/Users/f7b/spell`

Now, let's pray.

