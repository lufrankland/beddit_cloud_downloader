<div style="text-align: center;">

# Beddit Downloader Script  
<sub><sup>Want some silly badges? Of course you do!</sup></sub>  
<img src="https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg" alt="I mean I tried you could say" height="30" />
<img src="https://forthebadge.com/images/badges/built-by-codebabes.svg" alt="Trying to be beautiful and code with attitude" height="30" />
<img src="https://forthebadge.com/images/badges/built-with-love.svg" alt="I poured a little love into this project" height="30" />
<img src="https://forthebadge.com/images/badges/gluten-free.svg" alt="No bloating for this script" height="30" />

Do you want the raw sensor data from your Beddit but it's locked away with no API? Well have I got a bash script for you.

</div>

Beddit (now Apple owned) are shutting down their cloud services so this is a quick hacky script to allow you to download all your sleep data in raw format. The output is in JSON and came from a lot of reverse engineering the Beddit app itself.


## Preview
Once you've run this, you will get something like the following

![Beddit Downloader Script](https://i.imgur.com/H5850uE.png)

## Usage
1. Go into the folder you wish to empty the raw data into
2. Clone Repo/Download Script
3. Change the BEDDIT_USERNAME to your Beddit account username
4. Change the BEDDIT_PASSWORD to your Beddit account password
5. Change any other variables you see fit
6. Run the script (see below)
7. Wait as it creates you a login token and downloads data

```bash
$ bash ./get_beddit_cloud_data.sh
```

By default, it will create a folder called "raw_export_files" in the working directory. You can amend this

## Warnings

This is clunky and could be optimised so many ways. It is crude for a reason, they can turn off these APIs at any time.
Its all large JSON files. I've split the maximum limit of sessions/sleep records to 200 but if you go beyond about 300 on the Sessions data, it will timeout and you will get nothing. 60s max execution time it looks like.

## FAQ

**Q:** How do I use it  
**A:** See the instructions above. Everything is commented so go nuts.

**Q:** Will it work on Mac/Linux  
**A:** Yes, if you make sure you have bash, curl and sed; you should be all set

**Q:** Why didn't you mention windows?  
**A:** Eh, no time to test! Feel free to convert it to powershell but you might as well use the Bash on Windows

**Q:** Why did you make this?  
**A:** Apple turned a great product into a pretty unusable product by turning off all syncing features and they don't even know how to replace a faulty device.

**Q:** It has a lot of JSON... gonna combine anything or interpret it?  
**A:** Nah, just want my data

**Q:** Any plans on adding *[insert feature name here]*?  
**A:** Unlikely, it's just a quick fix for a problem and the API will go down soon so this project will die at that point.

**Q:** How did you figure this out?    
**A:** Was annoyed with slow syncing and spent a 20 hour caffeine filled explore of their API. Can't say much but it holds up to my ~~abuse~~ testing


## Donate

I would say if I've helped you, feel free to donate some magic internet money over to:
[bitcoin:1NEJcdBSbmGnsihKUiK5h4XrQ8rA3r4tgk](bitcoin:1NEJcdBSbmGnsihKUiK5h4XrQ8rA3r4tgk)

## License

MIT License

Copyright (c) 2018 Luna Frankland

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
