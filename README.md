# c8y2k
<br>
c8y2k is an unofficial CLI tool for Cumulocity development. This includes tools for

 - Development with Cumulocity Web SDK
 - Cumulocity Microservice Development

This tool is currently available for Linux, MacOS and Windows (with either WSL, Cygwin or Git Bash).

## IMPORTANT
THIS TOOL <b>DOES NOT</b> REPLACE <a href="https://www.npmjs.com/package/@c8y/cli">c8ycli</a> or <a href="https://www.npmjs.com/package/@c8y/cli">go-c8y-cli</a>!<br>
Both of these tools are meant for making development with the Cumulocity ecosystem easier. See it as an additional CLI tool rather than a replacement for one or both of the others.

## Download and install
You can download c8ycli either via the releases tab or by using tools such as <br/><br/>
wget
```bash
wget "https://raw.githubusercontent.com/anotherSimpleCoder/c8y2k-bash/main/c8y2k" && \
wget "https://raw.githubusercontent.com/anotherSimpleCoder/c8y2k-bash/main/install"
```

<br>
or cURL

```bash
curl "https://raw.githubusercontent.com/anotherSimpleCoder/c8y2k-bash/main/c8y2k" > c8y2k && \
curl "https://raw.githubusercontent.com/anotherSimpleCoder/c8y2k-bash/main/install" > install && \
chmod 777 c8y2k && chmod 777 install
```

After that you can either run c8y2k directly:

```bash
./c8ycli
```

or you can install it via the install script:

```bash
./install
```

## Functionalities
c8y2k currently offers the following functionalities:
<br/>
<br/>

### Cumulocity Web SDK
||
|----------------------------------------|
|Creating projects for the Cumulocity Web SDK|
|Adding components in a Cumulocity Web SDK projects|
|Add widgets to Cumulocity Widget projects|

<br/>

### Cumulocity Microservice Development
||
|----------------------------------------|
|Scaffolding a new Java Cumulocity Microservice project based on the <a href="https://github.com/SoftwareAG/cumulocity-microservice-archetype">offical Maven microservice archetype</a>|