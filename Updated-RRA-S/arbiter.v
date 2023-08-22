module arbiter(clk,comcyc,cyc3,cyc2,cyc1,cyc0,gnt,gnt3,gnt2,gnt1,gnt0,rst);
  input clk,cyc3,cyc2,cyc1,cyc0,rst;
  output reg comcyc,gnt3,gnt2,gnt1,gnt0;
  output reg[1:0] gnt;

  reg edg,lgnt0,lgnt1,lgnt2,lgnt3,lasmas,lmas0,lmas1;
  reg beg,lcomcyc;
  reg[1:0]lgnt;
  
  //Arbitration Logic

  always@(posedge clk)
    begin
      lgnt0 <= (~(rst) & ~ (lcomcyc) & ~ (lmas1) & ~ (lmas0) & ~ (cyc3) & ~ (cyc2) & ~ (cyc1) & cyc0)
      || (~(rst) & ~ (lcomcyc) & ~ (lmas1) & lmas0 & ~ (cyc3) & ~ (cyc2) & cyc0)
      || (~(rst) & ~(lcomcyc) & lmas1 & ~ (lmas0) & ~ (cyc3)  & cyc0)
      || (~(rst) & ~ (lcomcyc) & lmas1 & lmas0 & cyc0)
      || (~(rst) & lcomcyc & lgnt0);

      lgnt1 <= (~(rst) & ~ (lcomcyc) & ~ (lmas1) & ~ (lmas0) & cyc1)
      || (~(rst) & ~ (lcomcyc) & ~ (lmas1) & lmas0 & ~ (cyc3) & ~ (cyc2) & cyc1 & ~(cyc0))
      || (~(rst) & ~(lcomcyc) & lmas1 & ~ (lmas0) & ~ (cyc3)  & cyc1 & ~ (cyc0))
      || (~(rst) & ~ (lcomcyc) & lmas1 & lmas0 & cyc1 & ~(cyc0))
      || (~(rst) & lcomcyc & lgnt1);

      lgnt2 <= (~(rst) & ~ (lcomcyc) & ~ (lmas1) & ~ (lmas0) & cyc2 & (cyc1))
      || (~(rst) & ~ (lcomcyc) & ~ (lmas1) & lmas0 & cyc2)
      || (~(rst) & ~(lcomcyc) & lmas1 & ~ (lmas0) & ~ (cyc3)  & cyc2 & ~ (cyc1) & ~ (cyc0))
      || (~(rst) & ~ (lcomcyc) & lmas1 & lmas0 & cyc2 & ~ (cyc1) & ~ (cyc0))
      || (~(rst) & lcomcyc & lgnt2);

      lgnt3 <= (~(rst) & ~ (lcomcyc) & ~ (lmas1) & ~ (lmas0) & cyc3 & ~ (cyc2) & ~ (cyc1))
      || (~(rst) & ~ (lcomcyc) & ~ (lmas1) & lmas0 & cyc3 & ~ (cyc2))
      || (~(rst) & ~(lcomcyc) & lmas1 & ~ (lmas0) & cyc3)
      || (~(rst) & ~ (lcomcyc) & lmas1 & lmas0 & cyc3 & ~ (cyc2) & ~ (cyc1) & ~ (cyc0))
      || (~(rst) & lcomcyc & lgnt3);
    end
  //State Machine

  always@(cyc3,cyc2,cyc1,cyc0,lcomcyc)
    begin
      beg<=(cyc3 || cyc2 || cyc1 || cyc0) & ~ (lcomcyc);
    end
  always@(posedge clk)
    begin
      lasmas<=(beg & ~ (edg) & ~ (lasmas));
      edg<=(beg & ~ (edg) & lasmas) || (beg & edg & ~ (lasmas));

  // comcyc logic
      always@(cyc3,cyc2,cyc1,cyc0,lgnt3,lgnt2,lgnt1,lgnt0)
        begin
          lcomcyc<=(cyc3 & lgnt3) || (cyc2 & lgnt2) || (cyc1 & lgnt1) || (cyc0 & lgnt0);
        end

  //encoder logic
      always@(lgnt3,lgnt2,lgnt1,lgnt0)
        begin
          lgnt[1]<=lgnt3 || lgnt2;
          lgnt[0]<=lgnt3 || lgnt1;
        end
  //lmas register
      always@(posedge clk)
        begin
          if(rst)
            begin
              lmas1<=0;
              lmas0<=0;
            end
          else if(lasmas)
            begin
              lmas1<=lmas1;
              lmas0<=lmas0;
            end
        end

  // make visible
      always@(lcomcyc,lgnt,lgnt0,lgnt1,lgnt2,lgnt3)
        begin
          comcyc<=lcomcyc;
          gnt[1]<=lgnt[1];
          gnt[0]<=lgnt[0];
          gnt3<=lgnt3;
          gnt2<=lgnt2;
          gnt1<=lgnt1;
          gnt0<=lgnt0;
        end
      endmodule
