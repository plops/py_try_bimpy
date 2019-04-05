(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload '("cl-py-generator"
			 "cl-cpp-generator"
		       )))
(in-package :cl-py-generator)

;(setf *features* (union *features* '(:plot :pd :highres)))
;(setf *features* (set-difference *features* '(:highres)))

;https://towardsdatascience.com/get-started-with-gpu-image-processing-15e34b787480

(defun timer (name body)
  (let ((start (format nil "time_before_~a" name))
	(end (format nil "time_after_~a" name)))
   `(do0
     (setf ,start (current_milli_time))
     ,body
     (setf ,end (current_milli_time))
     (print (dot (string ,(format nil "~a time: {}ms" name))
		 (format (- ,end ,start)))))))




(progn
  (progn
  #.(in-package #:cl-cpp-generator)

  (defparameter *cl-program*
    (cl-cpp-generator::beautify-source
     `(with-compilation-unit
	  
	(decl ((sampler :type "__constant sampler_t" :init (|\|| CLK_NORMALIZED_COORDS_FALSE CLK_FILTER_NEAREST CLK_ADDRESS_CLAMP_TO_EDGE))))
	(function (morph_op_kernel ((in :type "__read_only image2d_t")
				    (op :type int)
				    (out :type "__write_only image2d_t"))
				   "__kernel void")
		  (let ((x :type "const int" :init (funcall get_global_id 0)))))))))

  #.(in-package #:cl-py-generator)
  (defparameter *path* "/home/martin/stage/py_try_bimpy/")
  (defparameter *code-file* "run_01_bimpy")
  (defparameter *source* (format nil "~a/source/~a" *path* *code-file*))

  (let* (
	 (code
	  `(do0
	    "#!/usr/bin/env python3" ;; pipenv run python
	    

	    (string3 ,(format nil "bimpy test code.
Usage:
  ~a [-vh]

Options:
  -h --help               Show this screen
  -v --verbose            Print debugging output
"
			      *code-file*))
	    
	    "# martin kielhorn 2019-04-05"
	    "# https://github.com/podgorskiy/bimpy"		
	    #+plot
	    (do0
	     (imports (matplotlib))
	     (imports ((plt matplotlib.pyplot)))
	     (plt.ion)
	     (setf font (dict ((string size) (string 5))))
	     (matplotlib.rc (string "font") **font)
	     ;(imports ((xrp xarray.plot)))
	     )
	    (imports (os
		      sys
		      docopt
		      traceback
		      (np numpy)
		      ;(cl pyopencl)
		      ;(pd pandas)
		      ;(xr xarray)
		      pathlib
		      time
		      ;(cl pyviennacl)
		      (b bimpy)))

	    
	    
	    (def current_milli_time ()
	      (return (int (round (* 1000 (time.time))))))
	    (do0
	     (class bcolors ()
		    (setf OKGREEN (string "\\033[92m")
			  WARNING (string "\\033[93m")
			  FAIL (string "\\033[91m")
			  ENDC (string "\\033[0m")))
	     "global g_last_timestamp"
	     (setf g_last_timestamp (current_milli_time))
	     (def milli_since_last ()
	       "global g_last_timestamp"
	       (setf current_time (current_milli_time)
		     res (- current_time g_last_timestamp)
		     g_last_timestamp current_time)
	       (return res))
	     (def fail (msg)
			  (print (+ bcolors.FAIL
				    (dot (string "{:8d} FAIL ")
					 (format (milli_since_last)))
				    msg
				    bcolors.ENDC))
			  (sys.stdout.flush))
	     (def plog (msg)
	       (print (+ bcolors.OKGREEN
			 (dot (string "{:8d} LOG ")
			      (format (milli_since_last)))
			 msg
			 bcolors.ENDC))
	       (sys.stdout.flush)))	    
	    (setf args (docopt.docopt __doc__ :version (string "0.0.1")))
	    (if (aref args (string "--verbose"))
		(print args))
	    (setf ctx (b.Context)
		  )
	    (ctx.init 600 600 (string "Hello"))
	    (setf str (b.String)
		  f (b.Float))
	    (while (not (ctx.should_close))
	      (with ctx
		    (b.text (string "hello world"))
		    (if (b.button (string "OK"))
			(print str.value))
		    (b.input_text (string "string") str 256)
		    (b.slider_float (string "float") f 0.0 1.0)))
	    )))
    (write-source *source* code)))
