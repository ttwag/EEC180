	component issp_booth is
		port (
			source     : out std_logic_vector(16 downto 0);        -- source
			source_clk : in  std_logic                     := 'X'  -- clk
		);
	end component issp_booth;

	u0 : component issp_booth
		port map (
			source     => CONNECTED_TO_source,     --    sources.source
			source_clk => CONNECTED_TO_source_clk  -- source_clk.clk
		);

