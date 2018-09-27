open OUnit2
open Image

let image_tests = [
  "square1" >:: (fun _ -> assert_equal (Math.create 4 4 1.0)
                    (Image.make_square (Math.create 4 4 1.0) 4));
]

let suite =  "test suite" >::: image_tests @ []

let _ = run_test_tt_main suite
