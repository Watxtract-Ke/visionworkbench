// __BEGIN_LICENSE__
// Copyright (C) 2006-2010 United States Government as represented by
// the Administrator of the National Aeronautics and Space Administration.
// All Rights Reserved.
// __END_LICENSE__

#include <test/Helpers.h>
#include <vw/Image/EdgeExtension.h>
#include <vw/Image/UtilityViews.h>
#include <vw/Image/Algorithms.h>
#include <vw/Stereo/rewrite/CostFunctions.h>
#include <vw/Stereo/rewrite/Correlation.h>

#include <boost/random/linear_congruential.hpp>

using namespace vw;
using namespace vw::stereo::rewrite;

template <typename  PixelT>
class Correlation : public ::testing::Test {
protected:
  Correlation(){}

  typedef PixelT pixel_type;
  typedef ImageView<PixelT> image_type;
  typedef ImageView<PixelMask<Vector2i> > result_type;
  typedef typename PixelChannelType<PixelT>::type channel_type;
  image_type input1, input2;
  Vector2i kernel_size;
  Vector2i search_volume;
  Vector2i solution;

  virtual void SetUp() {
    boost::rand48 gen(10);
    kernel_size = Vector2i(7,5);
    search_volume = Vector2i(7,12);
    solution = Vector2i(3,8);
    input1 = pixel_cast_rescale<pixel_type>(uniform_noise_view(gen,25,25));
    input2 = crop( edge_extend( input1, ConstantEdgeExtension() ), -solution[0], -solution[1],
                   25+search_volume[0]-1, 35+search_volume[1]-1);
  }

  template <class ImageT>
  void CheckResult( ImageViewBase<ImageT> const& imagebase ) {
    ImageT const& image = imagebase.impl();
    for ( int32 i = 0; i < image.cols(); i++ ) {
      for ( int32 j = 0; j < image.rows(); j++ ) {
        EXPECT_TRUE( is_valid(image(i,j)) );
        EXPECT_VW_EQ( solution, image(i,j).child() );
      }
    }
  }
};

typedef Correlation<PixelGray<uint8> > CorrelationGRAYU8;
typedef Correlation<PixelGray<int16> > CorrelationGRAYI16;
typedef Correlation<PixelGray<float> > CorrelationGRAYF32;
typedef Correlation<uint8>             CorrelationU8;

TEST_F( CorrelationGRAYU8, AbsDifference ) {
  result_type disparity =
    best_of_search_convolution<AbsoluteCost>( input1, input2,
                                              bounding_box( input1 ),
                                              search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYU8, SquaredDifference ) {
  result_type disparity =
    best_of_search_convolution<SquaredCost>( input1, input2,
                                             bounding_box( input1 ),
                                             search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYU8, CrossCorrelation ) {
  result_type disparity =
    best_of_search_convolution<NCCCost>( input1, input2,
                                         bounding_box( input1 ),
                                         search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYI16, AbsDifference ) {
  result_type disparity =
    best_of_search_convolution<AbsoluteCost>( input1, input2,
                                              bounding_box( input1 ),
                                              search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYI16, SquaredDifference ) {
  result_type disparity =
    best_of_search_convolution<SquaredCost>( input1, input2,
                                             bounding_box( input1 ),
                                             search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYI16, CrossCorrelation ) {
  result_type disparity =
    best_of_search_convolution<NCCCost>( input1, input2,
                                         bounding_box( input1 ),
                                         search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYF32, AbsDifference ) {
  result_type disparity =
    best_of_search_convolution<AbsoluteCost>( input1, input2,
                                              bounding_box( input1 ),
                                              search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYF32, SquaredDifference ) {
  result_type disparity =
    best_of_search_convolution<SquaredCost>( input1, input2,
                                             bounding_box( input1 ),
                                             search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationGRAYF32, CrossCorrelation ) {
  result_type disparity =
    best_of_search_convolution<NCCCost>( input1, input2,
                                         bounding_box( input1 ),
                                         search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationU8, AbsDifference ) {
  result_type disparity =
    best_of_search_convolution<AbsoluteCost>( input1, input2,
                                              bounding_box( input1 ),
                                              search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationU8, SquaredDifference ) {
  result_type disparity =
    best_of_search_convolution<SquaredCost>( input1, input2,
                                             bounding_box( input1 ),
                                             search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}

TEST_F( CorrelationU8, CrossCorrelation ) {
  result_type disparity =
    best_of_search_convolution<NCCCost>( input1, input2,
                                         bounding_box( input1 ),
                                         search_volume, kernel_size );
  ASSERT_EQ( 19, disparity.cols() );
  ASSERT_EQ( 21, disparity.rows() );
  ASSERT_TRUE( is_valid(disparity(10,10)) );
  CheckResult( disparity );
}
