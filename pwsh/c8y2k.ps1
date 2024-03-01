function help() {
    Write-Host "                                   .::     "
	Write-Host "           .:               .:::.: .::     "
	Write-Host "   .::: .::  .::  .::   .::.:    .:.::  .::"
	Write-Host " .::   .::     .:  .:: .::     .:: .:: .:: "
	Write-Host ".::      .:: .:      .:::    .::   .:.::   "
	Write-Host " .::   .::     .::    .::  .::     .:: .:: "
	Write-Host "   .:::  .::::       .::   .:::::::.::  .::"
	Write-Host "                   .::                     "
	Write-Host
	Write-Host "c8y2k - A little tool for making the Cumulocity development easier"
	Write-Host
	Write-Host "Syntax:"
	Write-Host "`tc8y2k <command>"
	Write-Host
	Write-Host "`tCommand:"
	Write-Host "`t`thelp`t`t`tOpens this page"
	Write-Host "`t`tnew`t`t`tCreates a new Cumulocity Web SDK project"
	Write-Host "`t`tnew-microservice`tCreates a new Cumulocity Java Microservice"
	Write-Host "`t`tnew-component`t`tCreates a new component"
	Write-Host "`t`tnew-widget`t`tCreares a new widget component"
}

function newComponent() {
    $entered = $false
    $componentName = ""

    while($entered -ne $true) {
        $componentName = Read-Host "Please enter your component name"
        
        if($componentName.Length -eq 0) {
            Write-Host "Please enter a valid component name"
        } else {
            $entered=$true
        }
    }

    # Content
    $componentTs = @"
import {Component, OnInit} from '@angular/core'

@Component({
    selector: '$componentName',
    templateUrl: '$componentName.component.html',
    styleUrls: ['$componentName.component.css'],
})
export class ${componentName}ComponentComponent implements OnInit {
    contructor(){}

    ngOnInit() {}
}
"@

    $factoryTs = @"
import {Injectable} from '@angular/core'
import {NavigatorNode, NavigatorNodeFactory} from '@c8y/ngx-components'

@Injectable()
export class ${componentName}NavigationFactory implements NavigatorNodeFactory {
    get() {
        return new NavigatorNode({
            label: '$componentName',
            icon: 'robot',
            path: '$componentName',
            prioirty: 100
        })
    }
}
"@

    $moduleTs = @"
import {NgModule} from '@angular/core'
import {RouterModule,Routes} from '@angular/router'
import {CoreModule,hookNavigator} from '@c8y/ngx-components'

import {${componentName}Component} from './$componentName.component'
import {${componentName}NavigationFactory} from './$componentName.factory'

const routes: Routes = [
    {
        path: '',
        pathMatch: 'full'
    },

    {
        path: '$componentName',
        component: '${componentName}Component'
    }
]

@NgModule({
    imports: [RouterModule.forChild(routes), CoreModule],
    exports: [],
    declarations: [${componentName}Component],
    providers: [hookNavigator(${componentName}NavigationFactory)]
})
export class ${componentName}Module{}
"@

    $serviceTs = @"
import {Injectable, resolveForwardRef} from '@angular/core'
import {Subject} from 'rxjs'

@Injectable()
export class ${componentName}Service {
    constructor() {}
}
"@

    mkdir "src/$componentName"
    
    Set-Location "src/$componentName"
    New-Item "$componentName.component.html"
    New-Item "$componentName.component.css"
    New-Item "$componentName.model.ts"
    Write-Output $componentTs > "$componentName.component.ts"
    Write-Output $factoryTs > "$componentName.factory.ts"
    Write-Output $moduleTs > "$componentName.module.ts"
    Write-Output $serviceTs > "$componentName.service.ts"
    Set-Location -

    Write-Host "Created component successfully"
}

function newWidget() {
    $entered = $false
    $widgetName = ""

    while($entered -ne $true) {
        $widgetName = Read-Host "Enter your widget name"

        if($widgetName.Length -eq 0) {
            Write-Host "Please enter a valid widget name"
        } else {
            $entered = $true
        }
    }

    # content
    $widgetTemplate = @"
<div class="p-1-16 p-r-16">
    <h1>{{'$widgetName'}}</h1>
</div>
"@

    $componentTs = @"
import {Component,Input,OnInit} from '@angular/core'

@Component({
    selector: '$widgetName',
    templateUrl: '$widgetName.component.html',
    styleUrls: ['$widgetName.component.css']
})
export class ${widgetName}WidgetComponent implements OnInit {
    @Input() config: {device: {id: string, name: string}}

    constructor() {}

    ngOnInit() {}
}
"@

    $moduleTs = @"
import {NgModule} from '@angular/core'
import {CoreModule, hookComponent} from '@c8y/ngx-components'
import {ContextWidgetConfig} from '@c8y/ngx-components/context-dashboard'

import {${widgetName}WidgetComponent} from './$widgetName.component'

@NgModule({
    imports: [CoreModule]
    exports: [],
    declarations: [${widgetName}WidgetComponent],
    providers: [hookComponent({
        id: '$widgetName.widget',
        label: '$widgetName',
        description: '$widgetName',
        component: ${widgetName}WidgetComponent,

        data: {
            settings: {
                noNewWidgets: false,
                ng1: {
                    options: {
                        noDeviceTarget: false,
                        groupSelectable: false
                    }
                }
            }
        } as ContextWidgetConfig
    })]
})
export class ${widgetName}WidgetModule{}
"@

    $serviceTs = @"
import {Injectable, resolveForwardRef} from '@angular/core'
import {Subject} from 'rxjs'

@Injectable()
"export class ${widgetName}WidgetService {
    constructor() {}
}
"@

    mkdir "src/$widgetName"
    Set-Location "src/$widgetName"
    New-Item "$widgetName.component.css"
    New-Item "$widgetName.model.ts"
    Write-Output $widgetTemplate > "$widgetName.component.html"
    Write-Output $componentTs > "$widgetName.component.ts"
    Write-Output $moduleTs > "$widgetName.module.ts"
    Write-Output $serviceTs > "$widgetName.service.ts"
}

function newProject() {
    $entered = $false
    $projectName = ""

    while($entered -ne $true) {
        $projectName = Read-Host "Enter your project name"
        
        if($projectName.Length -eq 0) {
            Write-Host "Please enter a valid project name!"
        } else {
            $entered=$true
        }
    }

    try {
        npx @c8y/cli@latest new $projectName
        Set-Location $projectName
        npm install
        Set-Location -
        
        Write-Host "Project $projectName successfully created!"
    } catch {
        error 20
    }
}

function newMicroservice() {
    git clone https://github.com/SoftwareAG/cumulocity-microservice-archetype
    {
        Set-Location "cumulocity-microservice-archetype"
		mvn install
    }
    Remove-Item -r cumulocity*
	mvn archetype:generate "-DarchetypeGroupId=cumulocity.microservice -DarchetypeArtifactId=cumulocity-microservice-archetype"

    Write-Host "Create microservice successfully"

    try {
        docker --version > /dev/null 2>&1
    } catch {
        Write-Host "It seems like Docker has not been installed on your machine."
		Write-Host "In order to deploy your microservice to Cumulocity, the Docker Engine is needed"
    }
}

function error() {
    param([int]$code)

    switch($code) {
        10 {
            Write-Host "npm is not installed or falsely configured!"
			Write-Host "c8y2k depends on npm, so in order to use it, please install npm!"
			Write-Host
			Write-Host "To install npm run:"

            switch($PSVersionTable.OS.Split(" ")[0]) {
                {$_ -in "Ubuntu", "Debian"} {
                    Write-Host "`tsudo apt-get install npm"
                }

                "Fedora" {
                    Write-Host "`tsudo yum install npm"
                }

                "Darwin" {
                    Write-Host "`tIf you use Homebrew:"
					Write-Host "`t`tbrew install node"
					Write-Host
					Write-Host "`tIf you use MacPorts:"
					Write-Host "`t`tsudo port install npm"
                }

                "Microsoft" {
                    Write-Host "`twinget install npm"
                }
            }
        }

        11 {
            Write-Host "The Cumulocity Web SDK supports node.js version 14.x.x"
			Write-Host "Please install another version or change your node version accordingly"
			Write-Host
			Write-Host "To install node.js for the according version you can install Node Version manager (nvm)"
			
            switch($PSVersionTable.OS.Split(" ")[0]) {
                {$_ -in "Ubuntu", "Debian", "Fedora", "Darwin"} {
                    Write-Host "`tcurl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
                }

                "Microsoft" {
                    Write-Host "`twinget install nvm"
                }
            }

            Write-Host
			Write-Host "After that you run"
			Write-Host "`tnvm install v14.21.3"
			Write-Host "`tnvm use v14.21.3" 
        }

        13 {
            Write-Host "Apache Maven is not installed or falsely configured!"
			Write-Host "c8y2k depends on Apache Maven, so in order to use it, please install Apache Maven!"
			Write-Host
			Write-Host "To install Apache Maven run:"

            switch($PSVersionTable.OS.Split(" ")[0]) {
                {$_ -in "Ubuntu", "Debian", "Darwin"} {
                    Write-Host "`twget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"
					Write-Host "`ttar -xvf apache-maven-*.tar.gz"
					Write-Host "`tmv apache-maven-* /opt/"
					Write-Host "`tM2_HOME='/opt/apache-maven-3.6.3'"
					Write-Host "`tPATH=`"`$M2_HOME/bin:`$PATH`""
					Write-Host "`texport PATH"
                }

                "Microsoft" {
                    Write-Host "`twget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"
					Write-Host "`ttar -xvf apache-maven-*.tar.gz"
					Write-Host "`tmv apache-maven-* <place where you want maven to live>"
					Write-Host
					Write-Host "After that set the environment variables accordingly"
                }
            }
        }

        14 {
            Write-Host "git is not installed or falsely configured!"
			Write-Host "c8y2k depends on git, so in order to use it, please install git!"
			Write-Host
			Write-Host "To install git, please run:"

            switch($PSVersionTable.OS.Split(" ")[0]) {
                "Ubuntu" {
                    Write-Host "`tsudo apt-get install git"
                }

                "Fedora" {
                    Write-Host "`tsudo yum install git"
                }

                "Darwin" {
                    Write-Host "`tIf you use Homebrew:"
					Write-Host "`t`tbrew install git"
					Write-Host
					Write-Host "`tIf you use MacPorts:"
					Write-Host "`t`tsudo port install git"
                }

                "Microsoft" {
                    Write-Host "`twinget install git"
                }
            }
        }

        20 {
            Write-Host "Exit due to node error!"
        }

    }

    exit $code
}



# Check for dependencies
$errorCode=0
try {
    $errorCode=10
    npm --version 2>&1 > $null 

    $errorCode=11
    node --version 2> $null | Select-String --Pattern "v14*" > $null 2>&1

    $errorCode=13
    mvn -v > $null 2>&1

    $errorCode=14
    git version > $null 2>&1
} catch {
    error $errorCode
}

switch($args[0]) {
    "help" {
        help
    }

    "new" {
        newProject
    }

    "new-component" {
        newComponent
    }

    "new-microservice" {
        newMicroservice
    }

    "new-widget" {
        newWidget
    }

    default {
        help
    }
}