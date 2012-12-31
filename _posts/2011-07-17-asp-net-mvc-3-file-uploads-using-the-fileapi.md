---
layout: post
title: Asp.net mvc 3 file uploads using the fileapi
---

I was recently given the task of adding upload progress bars to some internal applications. A quick search of the internet yielded <a href='http://swfupload.org/'>SwfUpload</a>. Which worked...but not in the way that I wanted. So I went the route of using the new <a href='http://www.w3.org/TR/FileAPI/'>FileApi</a>. It didn't function the way that I've been used to standard file uploads. This is how I made it work in <a href='http://www.asp.net/mvc/mvc3'>MVC3</a>.

#Setup

First let's just setup a basic upload form so that we have one that works in almost every browser.

    @using (Html.BeginForm("uploadfile", "home", 
        FormMethod.Post, new { enctype = "multipart/form-data" })) {
        <input id="files-to-upload" type="file" name="file" />
        <input type='submit' id='upload-files' value=' Upload Files ' />
    }

    [HttpPost]
    public ActionResult UploadFile(HttpPostedFileBase file) {
        if (file != null) {
            Uploads.Add(file);
        }
    
        return RedirectToAction("index);
    }


<strong>Uploads</strong> is just a static collection so that we can easily return the file if requested.

#Using the FileApi

Since this project is supposed to have a progress bar and allow multiple file uploads we're going to make a few changes to the form.

    @using (Html.BeginForm("uploadfile", "home", 
            FormMethod.Post, new { enctype = "multipart/form-data" })) {
        <input id="files-to-upload" type="file" multiple name="file" />
        <input type='submit' id='upload-files' value=' Upload Files ' />
        <div class='progress-bar'></div>
    }


Notice the <strong>multiple</strong> keyword added to the <strong>input</strong>. I've also added a <strong>progress-bar</strong> div for later. We need to override the submit button to use the FileApi rather than the standard POST.

    <script type="text/javascript">
    $(function () {
        //is the file api available in this browser
        //only override *if* available.
        if (new XMLHttpRequest().upload) {
            $("#upload-files").click(function () {
                //upload files using the api
                //The files property is available from the
                //input DOM object
                upload_files($("#files-to-upload")[0].files);
                return false;
            });
        }
    });

    //accepts the input.files parameter
    function upload_files(filelist) {
        if (typeof filelist !== "undefined") {
            for (var i = 0, l = filelist.length; i < l; i++) {
                upload_file(filelist[i]);
            }
        }
    }

    //each file upload produces a unique POST
    function upload_file(file) {
        xhr = new XMLHttpRequest();

        xhr.upload.addEventListener("progress", function (evt) {
            if (evt.lengthComputable) {
                //update the progress bar
                $(".progress-bar").css({
                    width: (evt.loaded / evt.total) * 100 + "%" 
                });
            }
        }, false);

        // File uploaded
        xhr.addEventListener("load", function () {
            $(".progress-bar").html("Uploaded");
            $(".progress-bar").css({ backgroundColor: "#fff" });
        }, false);

        xhr.open("post", "home/uploadfile", true);

        // Set appropriate headers
        // We're going to use these in the UploadFile method
        // To determine what is being uploaded.
        xhr.setRequestHeader("Content-Type", "multipart/form-data");
        xhr.setRequestHeader("X-File-Name", file.name);
        xhr.setRequestHeader("X-File-Size", file.size);
        xhr.setRequestHeader("X-File-Type", file.type);

        // Send the file
        xhr.send(file);
    }

    </script>


Now that we have this new upload script we're going to have to update the back end to accommodate. I've created a new model called <strong>UploadedFile</strong> that will hold our upload regardless of where it came from. 

    public class UploadedFile {
        public int FileSize { get; set; }
        public string Filename { get; set; }
        public string ContentType { get; set; }
        public byte[] Contents { get; set; }
    }


In our home controller I've added the following method. It checks to see where the upload came from. If it came from the normal POST the <strong>Request.Files</strong> will be populated otherwise it will be part of the post data.

    private UploadedFile RetrieveFileFromRequest() {
        string filename = null;
        string fileType = null;
        byte[] fileContents = null;
    
        if (Request.Files.Count > 0) { //they're uploading the old way
            var file = Request.Files[0];
            fileContents = new byte[file.ContentLength];
            fileType = file.ContentType;
            filename = file.FileName;
        } else if (Request.ContentLength > 0) {
            fileContents = new byte[Request.ContentLength];
            Request.InputStream.Read(fileContents, 0, Request.ContentLength);
            filename = Request.Headers["X-File-Name"];
            fileType = Request.Headers["X-File-Type"];
        }
    
        return new UploadedFile() {
            Filename = filename,
            ContentType = fileType,
            FileSize = fileContents != null ? fileContents.Length : 0,
            Contents = fileContents
        };
    }


The UploadFile method will change slightly to use <strong>RetrieveFileFromRequest</strong> instead of taking directly from the Request.Files. 

    [HttpPost]
    public ActionResult UploadFile() {
        UploadedFile file = RetriveFileFromRequest();
    
        if (file.Filename != null &&
            !Uploads.Any(f => f.Filename.Equals(file.Filename)))
                Uploads.Add(file);
    
        return RedirectToAction("index);
    }


It's that simple. The only real difference between the two methods is that the HttpRequest.Files is not populated when using the FileApi. This can easily be used to create a Drag/Drop scenario by passing <strong>e.dataTransfer.files</strong> from the <strong>drop</strong> event into <strong>upload_files</strong>. 

###-Ben Dornis