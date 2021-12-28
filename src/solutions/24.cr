require "big"

class Aoc2021::TwentyFour < Aoc2021::Solution
  property d_z_combos : Nil | Array(Hash(Int64, Array(ZValue)))

  def parse_input(file)
    lines = File.read_lines(file)
    lines.map do |line|
      split = line.split " "
      inst = split[0]

      arg1 = split.size > 1 ? split[1] : nil
      unless arg1.nil?
        arg1 = arg1.matches?(/\d/) ? arg1.to_i64 : arg1.chars[0]
      end

      arg2 = split.size > 2 ? split[2] : nil
      unless arg2.nil?
        arg2 = arg2.matches?(/\d/) ? arg2.to_i64 : arg2.chars[0]
      end
      { inst, arg1, arg2 }
    end
  end

  def part1(monad)
    max_from_d_z_combos
  end

  D_Z_COMBOS = [
    {
      1 => [0], 2 => [0], 3 => [0], 4 => [0], 5 => [0], 6 => [0],
      7 => [] of Int64, 8 => [] of Int64, 9 => [] of Int64
    },
    {
      1 => [5..13], 2 => [5..13], 3 => [5..13], 4 => [5..13], 5 => [5..13],
      6 => [] of Int64, 7 => [] of Int64, 8 => [] of Int64, 9 => [] of Int64
    },
    {
      1 => [5..13],
      2 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      3 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      4 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      5 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      6 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      7 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      8 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
      9 => [5..13, 142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358]
    },
    {
      1 => [130..133, 135..159, 161..185, 187..211, 213..237, 239..263, 265..289, 291..315, 317..341, 343..363, 3696, 3722, 3748, 3774, 3800, 3826, 3852, 3878, 3904, 4372, 4398, 4424, 4450, 4476, 4502, 4528, 4554, 4580, 5048, 5074, 5100, 5126, 5152, 5178, 5204, 5230, 5256, 5724, 5750, 5776, 5802, 5828, 5854, 5880, 5906, 5932, 6400, 6426, 6452, 6478, 6504, 6530, 6556, 6582, 6608, 7076, 7102, 7128, 7154, 7180, 7206, 7232, 7258, 7284, 7752, 7778, 7804, 7830, 7856, 7882, 7908, 7934, 7960, 8428, 8454, 8480, 8506, 8532, 8558, 8584, 8610, 8636, 9104, 9130, 9156, 9182, 9208, 9234, 9260, 9286, 9312],
      2 => [130..134, 136..160, 162..186, 188..212, 214..238, 240..264, 266..290, 292..316, 318..342, 344..363, 3697, 3723, 3749, 3775, 3801, 3827, 3853, 3879, 3905, 4373, 4399, 4425, 4451, 4477, 4503, 4529, 4555, 4581, 5049, 5075, 5101, 5127, 5153, 5179, 5205, 5231, 5257, 5725, 5751, 5777, 5803, 5829, 5855, 5881, 5907, 5933, 6401, 6427, 6453, 6479, 6505, 6531, 6557, 6583, 6609, 7077, 7103, 7129, 7155, 7181, 7207, 7233, 7259, 7285, 7753, 7779, 7805, 7831, 7857, 7883, 7909, 7935, 7961, 8429, 8455, 8481, 8507, 8533, 8559, 8585, 8611, 8637, 9105, 9131, 9157, 9183, 9209, 9235, 9261, 9287, 9313],
      3 => [130..135, 137..161, 163..187, 189..213, 215..239, 241..265, 267..291, 293..317, 319..343, 345..363, 3698, 3724, 3750, 3776, 3802, 3828, 3854, 3880, 3906, 4374, 4400, 4426, 4452, 4478, 4504, 4530, 4556, 4582, 5050, 5076, 5102, 5128, 5154, 5180, 5206, 5232, 5258, 5726, 5752, 5778, 5804, 5830, 5856, 5882, 5908, 5934, 6402, 6428, 6454, 6480, 6506, 6532, 6558, 6584, 6610, 7078, 7104, 7130, 7156, 7182, 7208, 7234, 7260, 7286, 7754, 7780, 7806, 7832, 7858, 7884, 7910, 7936, 7962, 8430, 8456, 8482, 8508, 8534, 8560, 8586, 8612, 8638, 9106, 9132, 9158, 9184, 9210, 9236, 9262, 9288, 9314],
      4 => [130..136, 138..162, 164..188, 190..214, 216..240, 242..266, 268..292, 294..318, 320..344, 346..363, 3699, 3725, 3751, 3777, 3803, 3829, 3855, 3881, 3907, 4375, 4401, 4427, 4453, 4479, 4505, 4531, 4557, 4583, 5051, 5077, 5103, 5129, 5155, 5181, 5207, 5233, 5259, 5727, 5753, 5779, 5805, 5831, 5857, 5883, 5909, 5935, 6403, 6429, 6455, 6481, 6507, 6533, 6559, 6585, 6611, 7079, 7105, 7131, 7157, 7183, 7209, 7235, 7261, 7287, 7755, 7781, 7807, 7833, 7859, 7885, 7911, 7937, 7963, 8431, 8457, 8483, 8509, 8535, 8561, 8587, 8613, 8639, 9107, 9133, 9159, 9185, 9211, 9237, 9263, 9289, 9315],
      5 => [130..137, 139..163, 165..189, 191..215, 217..241, 243..267, 269..293, 295..319, 321..345, 347..363, 3700, 3726, 3752, 3778, 3804, 3830, 3856, 3882, 3908, 4376, 4402, 4428, 4454, 4480, 4506, 4532, 4558, 4584, 5052, 5078, 5104, 5130, 5156, 5182, 5208, 5234, 5260, 5728, 5754, 5780, 5806, 5832, 5858, 5884, 5910, 5936, 6404, 6430, 6456, 6482, 6508, 6534, 6560, 6586, 6612, 7080, 7106, 7132, 7158, 7184, 7210, 7236, 7262, 7288, 7756, 7782, 7808, 7834, 7860, 7886, 7912, 7938, 7964, 8432, 8458, 8484, 8510, 8536, 8562, 8588, 8614, 8640, 9108, 9134, 9160, 9186, 9212, 9238, 9264, 9290, 9316],
      6 => [3701, 3727, 3753, 3779, 3805, 3831, 3857, 3883, 3909, 4377, 4403, 4429, 4455, 4481, 4507, 4533, 4559, 4585, 5053, 5079, 5105, 5131, 5157, 5183, 5209, 5235, 5261, 5729, 5755, 5781, 5807, 5833, 5859, 5885, 5911, 5937, 6405, 6431, 6457, 6483, 6509, 6535, 6561, 6587, 6613, 7081, 7107, 7133, 7159, 7185, 7211, 7237, 7263, 7289, 7757, 7783, 7809, 7835, 7861, 7887, 7913, 7939, 7965, 8433, 8459, 8485, 8511, 8537, 8563, 8589, 8615, 8641, 9109, 9135, 9161, 9187, 9213, 9239, 9265, 9291, 9317],
      7 => [3702, 3728, 3754, 3780, 3806, 3832, 3858, 3884, 3910, 4378, 4404, 4430, 4456, 4482, 4508, 4534, 4560, 4586, 5054, 5080, 5106, 5132, 5158, 5184, 5210, 5236, 5262, 5730, 5756, 5782, 5808, 5834, 5860, 5886, 5912, 5938, 6406, 6432, 6458, 6484, 6510, 6536, 6562, 6588, 6614, 7082, 7108, 7134, 7160, 7186, 7212, 7238, 7264, 7290, 7758, 7784, 7810, 7836, 7862, 7888, 7914, 7940, 7966, 8434, 8460, 8486, 8512, 8538, 8564, 8590, 8616, 8642, 9110, 9136, 9162, 9188, 9214, 9240, 9266, 9292, 9318],
      8 => [3703, 3729, 3755, 3781, 3807, 3833, 3859, 3885, 3911, 4379, 4405, 4431, 4457, 4483, 4509, 4535, 4561, 4587, 5055, 5081, 5107, 5133, 5159, 5185, 5211, 5237, 5263, 5731, 5757, 5783, 5809, 5835, 5861, 5887, 5913, 5939, 6407, 6433, 6459, 6485, 6511, 6537, 6563, 6589, 6615, 7083, 7109, 7135, 7161, 7187, 7213, 7239, 7265, 7291, 7759, 7785, 7811, 7837, 7863, 7889, 7915, 7941, 7967, 8435, 8461, 8487, 8513, 8539, 8565, 8591, 8617, 8643, 9111, 9137, 9163, 9189, 9215, 9241, 9267, 9293, 9319],
      9 => [3704, 3730, 3756, 3782, 3808, 3834, 3860, 3886, 3912, 4380, 4406, 4432, 4458, 4484, 4510, 4536, 4562, 4588, 5056, 5082, 5108, 5134, 5160, 5186, 5212, 5238, 5264, 5732, 5758, 5784, 5810, 5836, 5862, 5888, 5914, 5940, 6408, 6434, 6460, 6486, 6512, 6538, 6564, 6590, 6616, 7084, 7110, 7136, 7162, 7188, 7214, 7240, 7266, 7292, 7760, 7786, 7812, 7838, 7864, 7890, 7916, 7942, 7968, 8436, 8462, 8488, 8514, 8540, 8566, 8592, 8618, 8644, 9112, 9138, 9164, 9190, 9216, 9242, 9268, 9294, 9320]
    },
    {
        1 => [142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
        2 => [142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
        3 => [142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
        4 => [142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
        5 => [] of Int64, 6 => [] of Int64, 7 => [] of Int64, 8 => [] of Int64, 9 => [] of Int64
      },
    {
        1 => [3702, 3728, 3754, 3780, 3806, 3832, 3858, 3884, 3910, 4378, 4404, 4430, 4456, 4482, 4508, 4534, 4560, 4586, 5054, 5080, 5106, 5132, 5158, 5184, 5210, 5236, 5262, 5730, 5756, 5782, 5808, 5834, 5860, 5886, 5912, 5938, 6406, 6432, 6458, 6484, 6510, 6536, 6562, 6588, 6614, 7082, 7108, 7134, 7160, 7186, 7212, 7238, 7264, 7290, 7758, 7784, 7810, 7836, 7862, 7888, 7914, 7940, 7966, 8434, 8460, 8486, 8512, 8538, 8564, 8590, 8616, 8642, 9110, 9136, 9162, 9188, 9214, 9240, 9266, 9292, 9318],
        2 => [3703, 3729, 3755, 3781, 3807, 3833, 3859, 3885, 3911, 4379, 4405, 4431, 4457, 4483, 4509, 4535, 4561, 4587, 5055, 5081, 5107, 5133, 5159, 5185, 5211, 5237, 5263, 5731, 5757, 5783, 5809, 5835, 5861, 5887, 5913, 5939, 6407, 6433, 6459, 6485, 6511, 6537, 6563, 6589, 6615, 7083, 7109, 7135, 7161, 7187, 7213, 7239, 7265, 7291, 7759, 7785, 7811, 7837, 7863, 7889, 7915, 7941, 7967, 8435, 8461, 8487, 8513, 8539, 8565, 8591, 8617, 8643, 9111, 9137, 9163, 9189, 9215, 9241, 9267, 9293, 9319],
        3 => [3704, 3730, 3756, 3782, 3808, 3834, 3860, 3886, 3912, 4380, 4406, 4432, 4458, 4484, 4510, 4536, 4562, 4588, 5056, 5082, 5108, 5134, 5160, 5186, 5212, 5238, 5264, 5732, 5758, 5784, 5810, 5836, 5862, 5888, 5914, 5940, 6408, 6434, 6460, 6486, 6512, 6538, 6564, 6590, 6616, 7084, 7110, 7136, 7162, 7188, 7214, 7240, 7266, 7292, 7760, 7786, 7812, 7838, 7864, 7890, 7916, 7942, 7968, 8436, 8462, 8488, 8514, 8540, 8566, 8592, 8618, 8644, 9112, 9138, 9164, 9190, 9216, 9242, 9268, 9294, 9320],
        4 => [3705, 3731, 3757, 3783, 3809, 3835, 3861, 3887, 3913, 4381, 4407, 4433, 4459, 4485, 4511, 4537, 4563, 4589, 5057, 5083, 5109, 5135, 5161, 5187, 5213, 5239, 5265, 5733, 5759, 5785, 5811, 5837, 5863, 5889, 5915, 5941, 6409, 6435, 6461, 6487, 6513, 6539, 6565, 6591, 6617, 7085, 7111, 7137, 7163, 7189, 7215, 7241, 7267, 7293, 7761, 7787, 7813, 7839, 7865, 7891, 7917, 7943, 7969, 8437, 8463, 8489, 8515, 8541, 8567, 8593, 8619, 8645, 9113, 9139, 9165, 9191, 9217, 9243, 9269, 9295, 9321],
        5 => [3706, 3732, 3758, 3784, 3810, 3836, 3862, 3888, 3914, 4382, 4408, 4434, 4460, 4486, 4512, 4538, 4564, 4590, 5058, 5084, 5110, 5136, 5162, 5188, 5214, 5240, 5266, 5734, 5760, 5786, 5812, 5838, 5864, 5890, 5916, 5942, 6410, 6436, 6462, 6488, 6514, 6540, 6566, 6592, 6618, 7086, 7112, 7138, 7164, 7190, 7216, 7242, 7268, 7294, 7762, 7788, 7814, 7840, 7866, 7892, 7918, 7944, 7970, 8438, 8464, 8490, 8516, 8542, 8568, 8594, 8620, 8646, 9114, 9140, 9166, 9192, 9218, 9244, 9270, 9296, 9322],
        6 => [3707, 3733, 3759, 3785, 3811, 3837, 3863, 3889, 3915, 4383, 4409, 4435, 4461, 4487, 4513, 4539, 4565, 4591, 5059, 5085, 5111, 5137, 5163, 5189, 5215, 5241, 5267, 5735, 5761, 5787, 5813, 5839, 5865, 5891, 5917, 5943, 6411, 6437, 6463, 6489, 6515, 6541, 6567, 6593, 6619, 7087, 7113, 7139, 7165, 7191, 7217, 7243, 7269, 7295, 7763, 7789, 7815, 7841, 7867, 7893, 7919, 7945, 7971, 8439, 8465, 8491, 8517, 8543, 8569, 8595, 8621, 8647, 9115, 9141, 9167, 9193, 9219, 9245, 9271, 9297, 9323],
        7 => [3708, 3734, 3760, 3786, 3812, 3838, 3864, 3890, 3916, 4384, 4410, 4436, 4462, 4488, 4514, 4540, 4566, 4592, 5060, 5086, 5112, 5138, 5164, 5190, 5216, 5242, 5268, 5736, 5762, 5788, 5814, 5840, 5866, 5892, 5918, 5944, 6412, 6438, 6464, 6490, 6516, 6542, 6568, 6594, 6620, 7088, 7114, 7140, 7166, 7192, 7218, 7244, 7270, 7296, 7764, 7790, 7816, 7842, 7868, 7894, 7920, 7946, 7972, 8440, 8466, 8492, 8518, 8544, 8570, 8596, 8622, 8648, 9116, 9142, 9168, 9194, 9220, 9246, 9272, 9298, 9324],
        8 => [3709, 3735, 3761, 3787, 3813, 3839, 3865, 3891, 3917, 4385, 4411, 4437, 4463, 4489, 4515, 4541, 4567, 4593, 5061, 5087, 5113, 5139, 5165, 5191, 5217, 5243, 5269, 5737, 5763, 5789, 5815, 5841, 5867, 5893, 5919, 5945, 6413, 6439, 6465, 6491, 6517, 6543, 6569, 6595, 6621, 7089, 7115, 7141, 7167, 7193, 7219, 7245, 7271, 7297, 7765, 7791, 7817, 7843, 7869, 7895, 7921, 7947, 7973, 8441, 8467, 8493, 8519, 8545, 8571, 8597, 8623, 8649, 9117, 9143, 9169, 9195, 9221, 9247, 9273, 9299, 9325],
        9 => [3710, 3736, 3762, 3788, 3814, 3840, 3866, 3892, 3918, 4386, 4412, 4438, 4464, 4490, 4516, 4542, 4568, 4594, 5062, 5088, 5114, 5140, 5166, 5192, 5218, 5244, 5270, 5738, 5764, 5790, 5816, 5842, 5868, 5894, 5920, 5946, 6414, 6440, 6466, 6492, 6518, 6544, 6570, 6596, 6622, 7090, 7116, 7142, 7168, 7194, 7220, 7246, 7272, 7298, 7766, 7792, 7818, 7844, 7870, 7896, 7922, 7948, 7974, 8442, 8468, 8494, 8520, 8546, 8572, 8598, 8624, 8650, 9118, 9144, 9170, 9196, 9222, 9248, 9274, 9300, 9326]},
    {
         
          1 => [142..150, 168..176, 194..202, 220..228, 246..254, 272..280, 298..306, 324..332, 350..358],
          2 => [] of Int64, 3 => [] of Int64, 4 => [] of Int64, 5 => [] of Int64, 6 => [] of Int64,
          7 => [] of Int64, 8 => [] of Int64, 9 => [] of Int64
    },
    {
      1 => [3700, 3726, 3752, 3778, 3804, 3830, 3856, 3882, 3908, 4376, 4402, 4428, 4454, 4480, 4506, 4532, 4558, 4584, 5052, 5078, 5104, 5130, 5156, 5182, 5208, 5234, 5260, 5728, 5754, 5780, 5806, 5832, 5858, 5884, 5910, 5936, 6404, 6430, 6456, 6482, 6508, 6534, 6560, 6586, 6612, 7080, 7106, 7132, 7158, 7184, 7210, 7236, 7262, 7288, 7756, 7782, 7808, 7834, 7860, 7886, 7912, 7938, 7964, 8432, 8458, 8484, 8510, 8536, 8562, 8588, 8614, 8640, 9108, 9134, 9160, 9186, 9212, 9238, 9264, 9290, 9316],
      2 => [3701, 3727, 3753, 3779, 3805, 3831, 3857, 3883, 3909, 4377, 4403, 4429, 4455, 4481, 4507, 4533, 4559, 4585, 5053, 5079, 5105, 5131, 5157, 5183, 5209, 5235, 5261, 5729, 5755, 5781, 5807, 5833, 5859, 5885, 5911, 5937, 6405, 6431, 6457, 6483, 6509, 6535, 6561, 6587, 6613, 7081, 7107, 7133, 7159, 7185, 7211, 7237, 7263, 7289, 7757, 7783, 7809, 7835, 7861, 7887, 7913, 7939, 7965, 8433, 8459, 8485, 8511, 8537, 8563, 8589, 8615, 8641, 9109, 9135, 9161, 9187, 9213, 9239, 9265, 9291, 9317],
      3 => [3702, 3728, 3754, 3780, 3806, 3832, 3858, 3884, 3910, 4378, 4404, 4430, 4456, 4482, 4508, 4534, 4560, 4586, 5054, 5080, 5106, 5132, 5158, 5184, 5210, 5236, 5262, 5730, 5756, 5782, 5808, 5834, 5860, 5886, 5912, 5938, 6406, 6432, 6458, 6484, 6510, 6536, 6562, 6588, 6614, 7082, 7108, 7134, 7160, 7186, 7212, 7238, 7264, 7290, 7758, 7784, 7810, 7836, 7862, 7888, 7914, 7940, 7966, 8434, 8460, 8486, 8512, 8538, 8564, 8590, 8616, 8642, 9110, 9136, 9162, 9188, 9214, 9240, 9266, 9292, 9318],
      4 => [3703, 3729, 3755, 3781, 3807, 3833, 3859, 3885, 3911, 4379, 4405, 4431, 4457, 4483, 4509, 4535, 4561, 4587, 5055, 5081, 5107, 5133, 5159, 5185, 5211, 5237, 5263, 5731, 5757, 5783, 5809, 5835, 5861, 5887, 5913, 5939, 6407, 6433, 6459, 6485, 6511, 6537, 6563, 6589, 6615, 7083, 7109, 7135, 7161, 7187, 7213, 7239, 7265, 7291, 7759, 7785, 7811, 7837, 7863, 7889, 7915, 7941, 7967, 8435, 8461, 8487, 8513, 8539, 8565, 8591, 8617, 8643, 9111, 9137, 9163, 9189, 9215, 9241, 9267, 9293, 9319],
      5 => [3704, 3730, 3756, 3782, 3808, 3834, 3860, 3886, 3912, 4380, 4406, 4432, 4458, 4484, 4510, 4536, 4562, 4588, 5056, 5082, 5108, 5134, 5160, 5186, 5212, 5238, 5264, 5732, 5758, 5784, 5810, 5836, 5862, 5888, 5914, 5940, 6408, 6434, 6460, 6486, 6512, 6538, 6564, 6590, 6616, 7084, 7110, 7136, 7162, 7188, 7214, 7240, 7266, 7292, 7760, 7786, 7812, 7838, 7864, 7890, 7916, 7942, 7968, 8436, 8462, 8488, 8514, 8540, 8566, 8592, 8618, 8644, 9112, 9138, 9164, 9190, 9216, 9242, 9268, 9294, 9320],
      6 => [3705, 3731, 3757, 3783, 3809, 3835, 3861, 3887, 3913, 4381, 4407, 4433, 4459, 4485, 4511, 4537, 4563, 4589, 5057, 5083, 5109, 5135, 5161, 5187, 5213, 5239, 5265, 5733, 5759, 5785, 5811, 5837, 5863, 5889, 5915, 5941, 6409, 6435, 6461, 6487, 6513, 6539, 6565, 6591, 6617, 7085, 7111, 7137, 7163, 7189, 7215, 7241, 7267, 7293, 7761, 7787, 7813, 7839, 7865, 7891, 7917, 7943, 7969, 8437, 8463, 8489, 8515, 8541, 8567, 8593, 8619, 8645, 9113, 9139, 9165, 9191, 9217, 9243, 9269, 9295, 9321],
      7 => [3706, 3732, 3758, 3784, 3810, 3836, 3862, 3888, 3914, 4382, 4408, 4434, 4460, 4486, 4512, 4538, 4564, 4590, 5058, 5084, 5110, 5136, 5162, 5188, 5214, 5240, 5266, 5734, 5760, 5786, 5812, 5838, 5864, 5890, 5916, 5942, 6410, 6436, 6462, 6488, 6514, 6540, 6566, 6592, 6618, 7086, 7112, 7138, 7164, 7190, 7216, 7242, 7268, 7294, 7762, 7788, 7814, 7840, 7866, 7892, 7918, 7944, 7970, 8438, 8464, 8490, 8516, 8542, 8568, 8594, 8620, 8646, 9114, 9140, 9166, 9192, 9218, 9244, 9270, 9296, 9322],
      8 => [3707, 3733, 3759, 3785, 3811, 3837, 3863, 3889, 3915, 4383, 4409, 4435, 4461, 4487, 4513, 4539, 4565, 4591, 5059, 5085, 5111, 5137, 5163, 5189, 5215, 5241, 5267, 5735, 5761, 5787, 5813, 5839, 5865, 5891, 5917, 5943, 6411, 6437, 6463, 6489, 6515, 6541, 6567, 6593, 6619, 7087, 7113, 7139, 7165, 7191, 7217, 7243, 7269, 7295, 7763, 7789, 7815, 7841, 7867, 7893, 7919, 7945, 7971, 8439, 8465, 8491, 8517, 8543, 8569, 8595, 8621, 8647, 9115, 9141, 9167, 9193, 9219, 9245, 9271, 9297, 9323],
      9 => [3708, 3734, 3760, 3786, 3812, 3838, 3864, 3890, 3916, 4384, 4410, 4436, 4462, 4488, 4514, 4540, 4566, 4592, 5060, 5086, 5112, 5138, 5164, 5190, 5216, 5242, 5268, 5736, 5762, 5788, 5814, 5840, 5866, 5892, 5918, 5944, 6412, 6438, 6464, 6490, 6516, 6542, 6568, 6594, 6620, 7088, 7114, 7140, 7166, 7192, 7218, 7244, 7270, 7296, 7764, 7790, 7816, 7842, 7868, 7894, 7920, 7946, 7972, 8440, 8466, 8492, 8518, 8544, 8570, 8596, 8622, 8648, 9116, 9142, 9168, 9194, 9220, 9246, 9272, 9298, 9324]
    },
    {
      1 => [142, 168, 194, 220, 246, 272, 298, 324, 350],
      2 => [143, 169, 195, 221, 247, 273, 299, 325, 351],
      3 => [144, 170, 196, 222, 248, 274, 300, 326, 352],
      4 => [145, 171, 197, 223, 249, 275, 301, 327, 353],
      5 => [146, 172, 198, 224, 250, 276, 302, 328, 354],
      6 => [147, 173, 199, 225, 251, 277, 303, 329, 355],
      7 => [148, 174, 200, 226, 252, 278, 304, 330, 356],
      8 => [149, 175, 201, 227, 253, 279, 305, 331, 357],
      9 => [150, 176, 202, 228, 254, 280, 306, 332, 358]
    },
    {
      1 => [5], 2 => [6], 3 => [7], 4 => [8], 5 => [9], 6 => [10], 7 => [11], 8 => [12], 9 => [13]
    },
    {
      1 => [0], 2 => [0], 3 => [0], 4 => [0], 5 => [0], 6 => [0], 7 => [0],
      8 => [] of Int64, 9 => [] of Int64
    },
    {
      1 => [0],
      2 => [0],
      3 => [0],
      4 => [0],
      5 => [0],
      6 => [0],
      7 => [0, 11..19],
      8 => [0, 11..19],
      9 => [0, 11..19]},
    {
      1 => [0..8, 10..25, 295, 321, 347, 373, 399, 425, 451, 477, 503],
      2 => [0..9, 11..25, 296, 322, 348, 374, 400, 426, 452, 478, 504],
      3 => [0..10, 12..25, 297, 323, 349, 375, 401, 427, 453, 479, 505],
      4 => [0..11, 13..25, 298, 324, 350, 376, 402, 428, 454, 480, 506],
      5 => [0..12, 14..25, 299, 325, 351, 377, 403, 429, 455, 481, 507],
      6 => [0..13, 15..25, 300, 326, 352, 378, 404, 430, 456, 482, 508],
      7 => [301, 327, 353, 379, 405, 431, 457, 483, 509],
      8 => [302, 328, 354, 380, 406, 432, 458, 484, 510],
      9 => [303, 329, 355, 381, 407, 433, 459, 485, 511]
    },
    {
      1 => [11], 2 => [12], 3 => [13], 4 => [14], 5 => [15], 6 => [16], 7 => [17], 8 => [18], 9 => [19]
    }
   ]

  def find_iteration_d_z_combos
    cached = @d_z_combos
    return cached if cached

    d_z_combos_14 = d_z_combos(14, [0] of Int64)
    #debug d_z_combos_14
    #d_z_combos_14 = {9 => [19], 8 => [18], 7 => [17], 6 => [16], 5 => [15], 4 => [14], 3 => [13], 2 => [12], 1 => [11]}
    d_z_combos_13 = d_z_combos(13, d_z_combos_14.values.flatten)
    #debug d_z_combos_13 
    #d_z_combos_13 = {1 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 295, 321, 347, 373, 399, 425, 451, 477, 503], 2 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 296, 322, 348, 374, 400, 426, 452, 478, 504], 3 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 297, 323, 349, 375, 401, 427, 453, 479, 505], 4 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 298, 324, 350, 376, 402, 428, 454, 480, 506], 5 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 299, 325, 351, 377, 403, 429, 455, 481, 507], 6 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 300, 326, 352, 378, 404, 430, 456, 482, 508], 7 => [301, 327, 353, 379, 405, 431, 457, 483, 509], 8 => [302, 328, 354, 380, 406, 432, 458, 484, 510], 9 => [303, 329, 355, 381, 407, 433, 459, 485, 511]}
    d_z_combos_12 = d_z_combos(12, d_z_combos_13.values.flatten)
    #debug d_z_combos_12
    #d_z_combos_12 = {1 => [0], 2 => [0], 3 => [0], 4 => [0], 5 => [0], 6 => [0], 7 => [0, 11, 12, 13, 14, 15, 16, 17, 18, 19], 8 => [0, 11, 12, 13, 14, 15, 16, 17, 18, 19], 9 => [0, 11, 12, 13, 14, 15, 16, 17, 18, 19]}
    d_z_combos_11 = d_z_combos(11, d_z_combos_12.values.flatten)
    #debug d_z_combos_11
    #d_z_combos_11 = {1 => [0], 2 => [0], 3 => [0], 4 => [0], 5 => [0], 6 => [0], 7 => [0], 8 => [], 9 => []}
    d_z_combos_10 = d_z_combos(10, d_z_combos_11.values.flatten)
    d_z_combos_9 = d_z_combos(9, d_z_combos_10.values.flatten)
    d_z_combos_8 = d_z_combos(8, d_z_combos_9.values.flatten)
    d_z_combos_7 = d_z_combos(7, d_z_combos_8.values.flatten)
    d_z_combos_6 = d_z_combos(6, d_z_combos_7.values.flatten)
    d_z_combos_5 = d_z_combos(5, d_z_combos_6.values.flatten)
    d_z_combos_4 = d_z_combos(4, d_z_combos_5.values.flatten)
    d_z_combos_3 = d_z_combos(3, d_z_combos_4.values.flatten)
    d_z_combos_2 = d_z_combos(2, d_z_combos_3.values.flatten)
    d_z_combos_1 = d_z_combos(1, d_z_combos_2.values.flatten)
    d_z_combos = [
      d_z_combos_1, d_z_combos_2, d_z_combos_3, d_z_combos_4,
      d_z_combos_5, d_z_combos_6, d_z_combos_7, d_z_combos_8,
      d_z_combos_9, d_z_combos_10, d_z_combos_11, d_z_combos_12,
      d_z_combos_13, d_z_combos_14,
    ]
    @d_z_combos = d_z_combos
    d_z_combos
  end

  def max_from_d_z_combos
    d_z_combos = D_Z_COMBOS #find_iteration_d_z_combos
    digits = [] of Int64
    z = 0_i64
    d_z_combos.each.with_index do |combos, i|
      digit = nil
      combos.each do |d, z_values|
        if z_values.any? { |zv| zv == z || (zv.is_a?(Range) && zv.includes?(z)) }
          digit = d.to_i64 if digit.nil? || d > digit
        end
      end
      raise "digit nil" if digit.nil?
      digits << digit
      z = monad_iteration(i + 1, digit, z)
    end
    digits.map(&.to_s).join.to_i64
  end

  def min_from_d_z_combos
    d_z_combos = D_Z_COMBOS #find_iteration_d_z_combos
    digits = [] of Int64
    z = 0_i64
    d_z_combos.each.with_index do |combos, i|
      digit = nil
      combos.each do |d, z_values|
        if z_values.any? { |zv| zv == z || (zv.is_a?(Range) && zv.includes?(z)) }
          digit = d.to_i64 if digit.nil? || d < digit
        end
      end
      raise "digit nil" if digit.nil?
      digits << digit
      z = monad_iteration(i + 1, digit, z)
    end
    digits.map(&.to_s).join.to_i64
  end

  # for iteration, for each digit, find starting z that result in target_z
  alias ZValue = Int64 | Range(Int64, Int64)
  def d_z_combos(iteration, target_z : Array(ZValue), max = 10_000)
    combos = Hash(Int64, Array(Int64)).new

    (1..9).to_a.each do |digit|
      digit = digit.to_i64
      combos[digit] = Array(Int64).new
      #debug "d=#{digit}"
      (0..max).each do |prev_z|
        z = monad_iteration(iteration, digit.to_i64, prev_z.to_i64)
        #if prev_z % 1_000_000 == 0
          #debug "d=#{digit} prev_z=#{prev_z} z=#{z}"# target_z=#{target_z}"
        #end
        target_z.each do |t|
          if t == z || (t.is_a?(Range) && t.includes?(z))
            combos[digit] << prev_z.to_i64
            break
          end
        end
      end
    end

    #combos

    combos_w_ranges = Hash(Int64, Array(ZValue)).new

    combos.each do |d, z_a|
      combos_w_ranges[d] = [] of ZValue

      start_z = nil
      prev_z = nil

      z_a.sort.each do |z|
        if start_z.nil?
          start_z = z 
          prev_z = z 
          next
        end
        raise "prev z nil" if prev_z.nil?

        if z == prev_z + 1
          prev_z = z
        else
          combos_w_ranges[d] << ( (start_z == prev_z) ? start_z : (start_z..prev_z) )
          start_z = z
          prev_z = z
        end
      end

      if start_z && prev_z
        combos_w_ranges[d] << ( (start_z == prev_z) ? start_z : (start_z..prev_z) )
      end
    end

    combos_w_ranges 
  end

  def part2(program)
    min_from_d_z_combos
  end

  def monad_iteration(i : Int32, d : Int64, z : Int64)
    case i
    when 1 then z * 26 + d + 7
    when 2 then z * 26 + d + 15
    when 3 then z * 26 + d + 2
    when 4 then d + 3 == z % 26 ? z // 26 : z // 26 * 26 + d + 15
    when 5 then z * 26 + d + 14
    when 6 then d + 9 == z % 26 ? z // 26 : z // 26 * 26 + d + 2
    when 7 then z * 26 + d + 15
    when 8 then d + 7 == z % 26 ? z // 26 : z // 26 * 26 + d + 1
    when 9 then d + 11 == z % 26 ? z // 26 : z // 26 * 26 + d + 15
    when 10 then d + 4 == z % 26 ? z // 26 : z // 26 * 26 + d + 15
    when 11 then z * 26 + d + 12
    when 12 then z * 26 + d + 2
    when 13 then d + 8 == z % 26 ? z // 26 : z // 26 * 26 + d + 13
    when 14 then d + 10 == z % 26 ? z // 26 : z // 26 * 26 + d + 13
    else raise "i > 14"
    end
  end
  #R = [1, 1, 1, 26, 1, 26, 1, 26, 26, 26, 1, 1, 26, 26].map(&.to_i64) # s > 0 ? 1 : 26 
  #S = [12, 11, 12, -3, 10, -9, 10, -7, -11, -4, 14, 11, -8, -10].map(&.to_i64)
  #    +   +   +   -   +   -   +   -   -    -   +   +   -    -
  #T = [7, 15, 2, 15, 14, 2, 15, 1, 15, 15, 12, 2, 13, 13].map(&.to_i64)

  #def monad_iteration(i : Int32, d : Int64, z : Int64)
  #  s = S[i-1]
  #  r = R[i-1]
  #  t = T[i-1]
  #  #x = d == s + (z % 26) ? 0 : 1
  #  x = d < s ? 1 : d == s + (z % 26) ? 0 : 1
  #  ( (z // r) * (25 * x + 1) ) + ( (d + t) * x )
  #end

  #  # if DIGIT is S + overflow
  #  if d == s + overflow
  #    # S is -11 to 12
  #    # R = 1 if S positive (MIN 10!), 26 if S negative
  #    # positive S is min 10, and D is max 9, so this path is never executed
  #    #if S > 0
  #    #  z
  #    #else
  #      z // 26
  #    #end
  #  else
  #    if s > 0
  #      z * 26 + d + t
  #    else
  #      truncate(z) + d + t
  #    end
  #  end
  #  #if d == S[i-1] + (z % 26) 
  #  #  z // R[i-1]
  #  #else
  #  #  z // R[i-1] * 26 + d + T[i-1]
  #  #end
  #def monad_iteration(i : Int32, d : Int64, z : Int64)
  #  s = S[i-1]
  #  r = R[i-1]
  #  t = T[i-1]
  #  overflow = (z % 26) 
  #  if s > 0
  #    z * 26 + d + t
  #  elsif d == s + overflow
  #    z // 26
  #  else 
  #    z // 26 * 26 + d + t
  #  end
  #end
end
