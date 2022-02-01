#Provide compile object from CLI
$compile_object = $args[0]
#Verify if input is provided
if (!$compile_object) {
    Write-Output "Provide name of file to compile."
    return
}

#Verifiy if max runtime is valid
$max_runtime_cli = $args[1]
if (!$max_runtime_cli) {
    $set_max_runtime = 0
}
ElseIf ($max_runtime_cli -isnot [int]) {
    Write-Output "Max runtime must be integer."
    return  
}
else {
    $set_max_runtime = 1
}

#Check if there's ./data folder
$path_exist = Test-Path -Path "./data"
if (!$path_exist) {
    #If not run gen_data.ps1 first
    Write-Output "No data folder. Run gen_data.ps1"
    return
}

#Check if C file to compile exists in directory
if (!(Test-Path $compile_object)) {
    #If not return
    $message = $compile_object + " doesn't exist in directory."
    Write-Output $message
    return
}

#Verify if destination exists
$path_exist = Test-Path -Path "./test_results"
if (!$path_exist) {
    #If not create it
    New-Item -Path "./test_results" -ItemType Directory
}

#Compile
$compile_object_name = $compile_object.ToString().Split(".")[0]
gcc $compile_object -O3 -o $compile_object_name

#Check if gcc was successful
if ($LASTEXITCODE -eq 0) {
    $message = "Compiled file " + $compile_object + " into " + $compile_object_name + " successfuly."
    Write-Output $message 
}
else {
    $message = "Error compiling " + $compile_object + " into " + $compile_object_name + "."
    Write-Output $message
    return
}

#Start with 200s max_runtime go until 1000 with a step of 200
for ($max_runtime = 200; ($max_runtime -le 1000); $max_runtime += 200) {

    #If a max runtime is provided from cli just run once with max_runtime as provided
    if ($set_max_runtime) {
        $max_runtime = $max_runtime_cli
    }

    $message = "Starting tests for " + $compile_object_name + " with Max Runtime:" + $max_runtime + "s."
    Write-Output $message

    #Get random seed
    $seed = Get-Random -Minimum 10000 -Maximum 99999
    
    #Create out file name with usefull information
    $out_file = ("./test_results_seed_" + $($seed) + "_maxcputime_" + $($max_runtime) + "_" + $($compile_object_name) + ".txt")
    
    #Header info for R read_table
    "nexams prob seed nslots time" | Out-File -FilePath $out_file -Append

    #Sort files in alphanumerical order
    #(Powershell sort doesn't do this by default)
    $ToNatural = { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) }
    $files = Get-ChildItem "./data" | Sort-Object $ToNatural

    #Loop trough every file in the data directory
    for ($i = 0; $i -lt $files.Count; $i++ ) {

        #Run with desired arguments seed max_runtime filename
        $script_path = Resolve-Path ($compile_object_name + ".exe") 
        $output = & $script_path $seed $max_runtime $files[$i].FullName

        #From test file name extract usefull infomation
        $ntests = $files[$i].Name.Split("_")[2] 
        $prob = $files[$i].Name.Split("_")[3] 
        $seed = $files[$i].Name.Split("_")[4] -replace ".in", ""
        
        #Add usefull information to output file
        (($($ntests)) + " " + $($prob) + " " + $($seed) + " " + $($output))  | Out-File -FilePath $out_file -Append
    }

    #Move test results to destination folder
    Move-Item -Path $out_file -Destination "./test_results"

    $message = "Tests for " + $compile_object_name + " with Max Runtime:" + $max_runtime + "s done."
    Write-Output $message

    if ($set_max_runtime) {
        return;
    }
}
