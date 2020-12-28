open Format

let output_rom ?(x0=(-278)) ?(y0=197) ?(z0=(-1402)) rom name =
	(* Check the ROM size. *)
	if Array.length rom <> 128 then
		failwith "The ROM must have 128 words.";
	for i = 0 to 128 - 1 do
		if Array.length rom.(i) <> 32 then
			failwith "The ROM must only contain 32 bits words."
	done;

	let oc = ref (open_out (sprintf "rom/01_%s.rom" name)) in

	for j = 0 to 32 - 1 do
		(* Change file every two bits. *)
		if j mod 2 = 0 then begin
			let file_number = (j / 2 + 1) in
			let file_name =
				sprintf
					(if file_number < 10 then
						"rom/0%d_%s.rom"
					else
						"rom/%d_%s.rom")
					file_number
					name in
			oc := open_out file_name;
		end;

		let fmt = formatter_of_out_channel !oc in

		if j mod 2 = 0 then
			fprintf fmt "summon falling_block ~ ~1 ~ {Time:1,BlockState:{Name:air},Passengers:[@.{id:falling_block,Time:1,Passengers:[@.{id:command_block_minecart,Command:'gamerule commandBlockOutput false'},@.";

		(* For all word print its j-th bit. *)
		for i = 0 to 128 - 1 do
			let block =
				if rom.(i).(j) then
					"redstone_wall_torch[facing=west]"
				else
					"air" in
			let x = x0 + 2 * (i mod 16) in
			let y = y0 + 4 * (i / 16) in
			let z = z0 - 2 * j in
			fprintf fmt "{id:command_block_minecart,Command:'setblock %d %d %d minecraft:%s'},@." x y z block
		done;

		(* Say the number of the command block. *)
		if j mod 2 <> 0 then begin
				fprintf fmt "{id:command_block_minecart,Command:'say Loading rom %s %d/%d.'},@." name (j / 2 + 1) 16;

			(* Kill the minecarts. *)
			fprintf fmt "{id:command_block_minecart,Command:'summon falling_block ~ ~1 ~ {Time:1,Passengers:[{id:command_block_minecart,Command:\"killall minecarts sysnum\"}]}'}@.]}]}@.";
			close_out !oc;
		end;
	done;
	close_out !oc

(* Test. *)
let binary n k =
	(n / (1 lsl k)) mod 2 = 1

let create_rom f =
	Array.init 128 (fun i -> Array.init 32 (f i))

let empty_rom =
	create_rom (fun _ -> (fun _ -> false))

let full_rom =
	create_rom (fun _ -> (fun _ -> true))

let binary_rom =
	create_rom (fun i -> (fun j -> binary i j))

let count_rom =
	create_rom (fun i -> (fun j -> i mod 32 = j))

let alternating_rom =
	create_rom (fun i -> (fun j -> i mod 2 = j mod 2))

(*    pc; flag;hl; ALU    ; read 1    ; imm 0-3   ; write     ; imm 7-4   ; read 2    ;*)
let nop =
	[| 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]
let loadi_1_2 =
	[| 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]
let loadi_12_6 =
	[| 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]
let add_2_3_3 =
	[| 1; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 0 |]
let xor_3_1_4 =
	[| 1; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0 |]
let add_6_4_carry_in_5 =
	[| 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0 |]
let jmp_negative_3 =
	[| 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]
let halt_7 =
	[| 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]

let counter_list =
	[
		nop;
		loadi_1_2;
		loadi_12_6;
		add_2_3_3;
		xor_3_1_4;
		add_6_4_carry_in_5;
		jmp_negative_3;
		halt_7;
	]

let counter_rom =
	let rom = create_rom (fun _ -> fun _ -> false) in
	let rec aux i = function
		| []		-> ()
		| t :: q	-> rom.(i) <- Array.map (fun j -> j = 1) t; aux (i + 1) q
	in aux 0 counter_list;
	rom

let () =
	output_rom empty_rom "empty";
	output_rom full_rom "full";
	output_rom binary_rom "binary";
	output_rom count_rom "count";
	output_rom alternating_rom "alternating";
	output_rom counter_rom "counter";

