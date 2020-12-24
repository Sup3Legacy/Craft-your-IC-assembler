open Format

let output_rom ?(x0=(-157)) ?(y0=197) ?(z0=(-1309)) rom name =
	if Array.length rom <> 128 then
		failwith "The ROM must have 128 words.";
	for i = 0 to 128 - 1 do
		if Array.length rom.(i) <> 16 then
			failwith "The ROM must only contain 16 bits words."
	done;

	let oc = ref (open_out (sprintf "1_%s.rom" name)) in

	for j = 0 to 16 - 1 do
		if j mod 2 = 0 then
			oc := open_out (sprintf "%d_%s.rom" (j / 2 + 1) name);

		let fmt = formatter_of_out_channel !oc in

		if j mod 2 = 0 then
			fprintf fmt "summon falling_block ~ ~1 ~ {Time:1,BlockState:{Name:air},Passengers:[@.{id:falling_block,Time:1,Passengers:[@.{id:command_block_minecart,Command:'gamerule commandBlockOutput false'},@.";

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

		if j mod 2 <> 0 then begin
			fprintf fmt "{id:command_block_minecart,Command:'say Loading rom %s %d/%d.'},@." name (j / 2 + 1) 8;
			fprintf fmt "{id:command_block_minecart,Command:'summon falling_block ~ ~1 ~ {Time:1,Passengers:[{id:command_block_minecart,Command:\"killall minecarts sysnum\"}]}'}@.]}]}@.";
			close_out !oc;
		end;
	done;
	close_out !oc

(* Test. *)
let binary n k =
	(n / (1 lsl k)) mod 2 = 1

let create_rom f =
	Array.init 128 (fun i -> Array.init 16 (f i))

let empty_rom =
	create_rom (fun _ -> (fun _ -> false))

let full_rom =
	create_rom (fun _ -> (fun _ -> true))

let binary_rom =
	create_rom (fun i -> (fun j -> binary i j))

let count_rom =
	create_rom (fun i -> (fun j -> i mod 16 = j))

let alternating_rom =
	create_rom (fun i -> (fun j -> i mod 2 = j mod 2))

let () =
	output_rom empty_rom "empty";
	output_rom full_rom "full";
	output_rom binary_rom "binary";
	output_rom count_rom "count";
	output_rom alternating_rom "alternating"

