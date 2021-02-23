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
